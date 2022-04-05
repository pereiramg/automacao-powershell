<#
    Objetivo: Mover servidores para folder
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>

Write-Host "`n`n =================================== Mover servidores para folder =================================== " -ForegroundColor Green

Write-Host "`nImportando o modulo do PowerCli`n" -ForegroundColor Green
Import-Module VMware.VimAutomation.Core -EA SilentlyContinue

Write-Host "`n`n=================== Captura de informações =================`n`n" -ForegroundColor Green
$csv_input = Read-Host "Insira o caminho com os dados dos servidores e disco"
$csv_info = Import-Csv $csv_input -UseCulture
$senha_vmware = Get-Credential -Message "Insira usuário e senha para acesso ao VMware"

foreach ($line in $csv_info) {
    
    $Vcenter = $line.Vcenter
    $Vcenter = $Vcenter.Trim()

    $NameVM = ($line.NameVM).toUpper()
    $NameVM = $NameVM.Trim()

    $vmFolder = $line.folder
    $vmDatacenter = $line.datacenter

    Write-Host "`n`n=================== Conectando no $Vcenter =======================`n`n"
    do{
        try{
            Connect-VIServer $Vcenter -Credential $senha_vmware -Force
        }catch [System.ServiceModel.Security.SecurityNegotiationException]{
            Write-Host "Realizando nova tentativa de conexão" -ForegroundColor Yellow
        }

        try{
            $lasterror = [string]$Error[0].Exception.GetType().FullName
        }catch [System.Management.Automation.RuntimeException]{
            $lasterror = " "
        }$Error.Clear()
    }until( $lasterror -ne "System.ServiceModel.Security.SecurityNegotiationException")

    Write-Host "Conectado com sucesso no $Vcenter"

    $vmObj = Get-VM -Name $NameVM
    $inventoryLocation = Get-Datacenter -Name $vmDatacenter | Get-Folder $vmFolder

    #Movendo para o folder
    Move-VM -vm $vmObj -InventoryLocation $inventoryLocation -RunAsync
    
    Write-Host "Realizado o move com sucesso" -ForegroundColor Green
        
    Disconnect-VIServer -Confirm:$false -EA SilentlyContinue
}
