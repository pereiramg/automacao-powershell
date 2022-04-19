<#
    Objetivo: Extrair relatorios de discos RDM
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>

#import de module
Write-Host "`nImportando o modulo do PowerCli"
Import-Module VMware.VimAutomation.Core -ErrorAction SilentlyContinue

Write-Host "`n`n =================================== Captura de informações =================================== " -ForegroundColor Green

$servidores = Get-Content(Read-Host "Insira o caminho do arquivo txt com os dados dos servidores")
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


Write-Host "`n`n=================== Extrair relatorios de discos RDM ==================`n`n"

$report = @()

foreach($vm in $servidores){
    $vm = Get-VM $vm | Get-View
    foreach($dev in $vm.Config.Hardware.Device){
        if(($dev.gettype()).Name -eq "VirtualDisk"){
            #if(($dev.Backing.CompatibilityMode -eq "physicalMode") -or ($dev.Backing.CompatibilityMode -eq "virtualMode")){
                $row = "" | select VMName, VMHost, HDDeviceName, HDName, HDFileName, HDMode, HDSize, HDDisplayName, LUN
                $row.VMName = $vm.Name
                $esx = Get-View $vm.Runtime.Host
                $row.VMHost = ($esx).Name
                $row.HDDeviceName = $dev.Backing.DeviceName
                $row.HDName = $dev.DeviceInfo.Label
                $row.HDFileName = $dev.Backing.FileName
                $row.HDMode = $dev.Backing.CompatibilityMode
                $row.HDSize = [System.Math]::Round($dev.CapacityInKB / 1048576)
                $row.HDDisplayName = ($esx.Config.StorageDevice.ScsiLun | where {$_.Uuid -eq $dev.Backing.LunUuid}).CanonicalName
                if($row.HDDisplayName -ne $null){
                    $lun = Get-ScsiLun -VmHost $row.VMHost -CanonicalName $row.HDDisplayName
                }
                $row.LUN = $lun.RuntimeName.SubString($lun.RuntimeName.LastIndexof("L")+1)
                $report += $row
            #}
        }
    }
}
$report | Export-Csv C:\temp\servidoresRDM.csv

Clear-Variable report