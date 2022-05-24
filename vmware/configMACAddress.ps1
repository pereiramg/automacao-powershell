<#
    Objetivo: Configurar o MAC Address em servidores
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>

Write-Host -ForegroundColor Green "========================================= Configurar o MAC Address em servidores ========================================="

#import de module
Write-Host "`nImportando o modulo do PowerCli"
Import-Module VMware.VimAutomation.Core -ErrorAction SilentlyContinue

Write-Host "`n`n =================================== Captura de informações =================================== " -ForegroundColor Green

$csvInput = Read-Host "Insira o caminho do arquivo csv para a criação dos servidores"
$csvInfo = Import-Csv $csvInput -UseCulture
$vcenter = Read-Host "Insira o nome do VCenter para se conectar"
$senhaVMware = Get-Credential -Message "Insira usuario e senha para acesso ao VMware"


Write-Host "`n`n=================== Conectando no $vcenter =======================`n`n" -ForegroundColor Green
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

if ($Global:DefaultVIServers){
    Write-Host "Conectado com sucesso no $vcenter"
}else{
    Write-Host "Não foi possivel se conectar, verificar..." -ForegroundColor Yellow
    exit
}

Write-Host "`n`n =================================== Iniciando as configurações do MAC Address =================================== " -ForegroundColor Green

foreach ($line in $csvInfo){

    $nameVM = ($line.nameVM).ToUpper()
    $nameVM = $nameVM.Trim()

    $NetAdpt = "Network adapter 1"

    $MACAddress = $line.MACAddress
    $MACAddress = $MACAddress.Trim()


    #Desligando a VM
    Write-Host "Desligando a $nameVM" -ForegroundColor Green
    Stop-VM $nameVM -Confirm:$false

    #Validando se o servidor desligou
    do{
        Write-Host "Servidor ainda ligado, aguarde um momento" -ForegroundColor Green
        Start-Sleep 2
    }while((Get-VM $nameVM | Select-Object PowerState -ExpandProperty PowerState) -eq "PoweredOn")


    # Realizando os ajustes
    Get-VM -Name $nameVM | Get-NetworkAdapter -Name $NetAdpt | Set-NetworkAdapter -MacAddress $MACAddress -Confirm:$false

    #Ligando a VM
    Write-Host "`nLigando a $nameVM" -ForegroundColor Green
    Start-VM $nameVM -Confirm:$false
}

Write-Host "`nRealizado os ajustes em todos os servidores`n" -ForegroundColor Green

Disconnect-VIServer $vcenter -Confirm:$false

Pause