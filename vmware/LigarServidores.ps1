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

$csvEntradaCaminho = Read-Host "Insira o caminho do arquivo CSV dos servidores para serem ligados"

$csvEntradaTratado = Import-Csv $csvEntradaCaminho -UseCulture
$senhaVMware = Get-Credential -Message "Insira usuario e senha para acesso ao VMware"

foreach ($line in $csvEntradaTratado){

    #Capturando os dados do CSV
    $vcenterName = $line.Vcenter
    $vcenter

}




