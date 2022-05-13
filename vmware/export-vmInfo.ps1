<#
    Objetivo: Export-VMInfo
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>

Write-Host "`n`n=================== Export-VMInfo ==================`n`n" -ForegroundColor Green

#import de module
Write-Host "`nImportando o modulo do PowerCli"
Import-Module VMware.VimAutomation.Core -ErrorAction SilentlyContinue

$vcenter = Read-Host "Insira o nome do VCenter para se conectar"
$senhaVMware = Get-Credential -Message "Insira usuario e senha para acesso ao VMware"


Write-Host "`n=================== Conectando no $vcenter  =======================`n" -ForegroundColor Green
    do{
        try{
            Connect-VIServer $vcenter -Credential $senhaVMware -Force
        }catch [System.ServiceModel.Security.SecurityNegotiationException]{
            Write-Host "Realizando nova tentativa de conexão" -ForegroundColor Yellow
        }

        try{
            $lasterror = [string]$Error[0].Exception.GetType().FullName
        }catch [System.Management.Automation.RuntimeException]{
            $lasterror = " "
        }$Error.Clear()
    }until( $lasterror -ne "System.ServiceModel.Security.SecurityNegotiationException")

    if ($Global:DefaultVIServers -ne $null){
        Write-Host "Conectado com sucesso no $vcenter"
    }else{
        Write-Host "Não foi possivel se conectar, verificar..." -ForegroundColor Yellow
        exit
    }


# Criação da função
function Export-VMInfo {
    $servers = Get-Content(Read-Host "Digite o nome do TXT onde estao as informacoes das VM's")
    
    foreach($server in $servers){
        Get-VM $server | 
        Select-Object Name,PowerState,
        @{N= "Cluster"; E = { $_.vmhost.parent }},
        @{N = "Host"; E = {$_.vmhost }},
        @{N = "VirtualPortGroup"; E = { Get-VM $server | Get-VirtualPortGroup }},
        MemoryGB,
        ProvisionedSpaceGB,
        Folder,
        @{N = "VCenter"; E = { $_.uid.split("@")[1].split(":")[0] }}
    }
}

Export-VMinfo | Export-Csv "C:\temp\ExportInfo.csv"

Write-Host "Arquivo salvo em C:\temp\ExportInfo.csv"

pause