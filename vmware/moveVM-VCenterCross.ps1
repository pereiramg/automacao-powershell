<#
    Objetivo: Movendo servidores entre host esxi e VCenters
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>

Write-Host -ForegroundColor Green "========================================= Movendo servidores entre host esxi e VCenters ========================================="

#import de module
Write-Host "`nImportando o modulo do PowerCli"
Import-Module VMware.VimAutomation.Core -ErrorAction SilentlyContinue

Write-Host "`n`n =================================== Captura de informações =================================== " -ForegroundColor Green

$csv_input = Read-Host "Insira o caminho do arquivo CSV com os dados dos servidores"
$csv_info = Import-Csv $csv_input -UseCulture
$senhaVMware = Get-Credential -Message "Insira usuario e senha para acesso ao VMware"


foreach ($line in $csv_info){
    #Capturando os dados do CSV
    $vcenterOrigem = $line.VcenterOrigem
    $vcenterOrigem =  $vcenterOrigem.Trim()

    $vcenterDestino = $line.VcenterDestino
    $vcenterDestino =  $vcenterDestino.Trim()

    $nameVM = $line.nameVM
    $vmObj = Get-VM -Name $nameVM
    $target_pg = @()
    foreach ($item in $line.targetPortGroup)



    Write-Host "`n`n=================== Conectando no $vcenterOrigem - Origem e $vcenterDestino - Destino =======================`n`n"
    do{
        try{
            Connect-VIServer $vcenterOrigem -Credential $senhaVMware -Force
            Connect-VIServer $vcenterDestino -Credential $senhaVMware -Force
        }catch [System.ServiceModel.Security.SecurityNegotiationException]{
            Write-Host "Realizando nova tentativa de conexão" -ForegroundColor Yellow
        }

        try{
            $lasterror = [string]$Error[0].Exception.GetType().FullName
        }catch [System.Management.Automation.RuntimeException]{
            $lasterror = " "
        }$Error.Clear()
    }until( $lasterror -ne "System.ServiceModel.Security.SecurityNegotiationException")

    Write-Host "Conectado com sucesso no $vcenterOrigem - Origem e $vcenterDestino - Destino"

    #Deslligando o servidor
    if((Get-VM $nameVM | Select-Object PowerState -ExpandProperty PowerState) -eq "PoweredOn"){
        Write-Host "Desligando a $nameVM" -ForegroundColor Green
        Stop-VM $nameVM -Confirm:$false
    }

    #Validando se o servidor desligou
    do{
        Write-Host "Servidor ainda ligado, aguarde um momento" -ForegroundColor Green
        Start-Sleep 2
    }while((Get-VM $newName | Select-Object PowerState -ExpandProperty PowerState) -eq "PoweredOn")






