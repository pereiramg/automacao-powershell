<#
    Objetivo: Processo para ligar servidores pelo VMWARE
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>


Write-Host -ForegroundColor Green "========================================= Processo para ligar servidores pelo VMWARE ========================================="

#import de module
Write-Host "`nImportando o modulo do PowerCli"
Import-Module VMware.VimAutomation.Core -ErrorAction SilentlyContinue

Write-Host "`n`n =================================== Informacoes necessarias =================================== "

$nameVMs = Get-Content(Read-Host "Informe o caminho do txt com os nomes dos servidores para serem ligados ")

$vcenter = Read-Host "Insira o nome do VCenter para se conectar"
$senhaVMware = Get-Credential -Message "Insira usuario e senha para acesso ao VMware"


Write-Host "`n`n=================== Conectando no $vcenter  =======================`n`n"
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

    Write-Host "Conectado com sucesso no $vcenter"


foreach ($vm in $nameVMs){

    Get-VM -Name $vm
    Start-VM $nameVM -Confirm:$false
}

