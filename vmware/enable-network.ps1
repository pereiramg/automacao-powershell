<#
    Objetivo: Ativar uma interface de Rede disable no VMware
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>


Write-Host "`n`n =============================== Ativar uma interface de Rede disable no VMware ================================ " -ForegroundColor Green

#import de module
Write-Host "`nImportando o modulo do PowerCli"
Import-Module VMware.VimAutomation.Core -ErrorAction SilentlyContinue

Write-Host "`n`n =================================== Captura de informações =================================== " -ForegroundColor Green

$csv_input = Read-Host "Insira o caminho do arquivo CSV com os dados dos servidores"
$csv_info = Import-Csv $csv_input -UseCulture
$senhaVMware = Get-Credential -Message "Insira usuario e senha para acesso ao VMware"

foreach ($line in $csv_info){
    #Capturando os dados do CSV
    $vcenter = $line.Vcenter
    $vcenter =  $vcenter.Trim()

    $nameVM = $line.nameVM
    $netAdpt = $line.Network_Adpter

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
        Write-Host "Conectado com sucesso no $vcenter" -ForegroundColor Green
    }else{
        Write-Host "Não foi possivel se conectar, verificar..." -ForegroundColor Yellow
        exit
    }

    Get-VM -Name $nameVM | Get-NetworkAdapter -Name $netAdpt | Set-NetworkAdapter -StartConnected:$true -Connected:$true -Confirm:$false
    # Montar no futuro uma validação para sair essa resposta
    Write-Host "`nPlaca de rede ativada com sucesso" -ForegroundColor Green
}

Pause