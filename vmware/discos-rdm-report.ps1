<#
    Objetivo: Extrair relatorios de discos RDM
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>

Write-Host "`n`n=================== Extrair relatorios de discos RDM ==================`n`n"


Connect-VIServer 

$report = @()

# Arquivo txt com a lista dos servidores
$servidores = Get-Content C:\temp\servidores.txt

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
                $lun = Get-ScsiLun -VmHost $row.VMHost -CanonicalName $row.HDDisplayName
                $row.LUN = $lun.RuntimeName.SubString($lun.RuntimeName.LastIndexof("L")+1)
                $report += $row
            #}
        }
    }
}
$report | Export-Csv C:\temp\servidoresRDM.csv

Clear-Variable report