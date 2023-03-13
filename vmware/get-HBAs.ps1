<#
    Objetivo: Captura dos WWN e LUN ID
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>

Write-Host -ForegroundColor Green "========================================= Captura dos WWN e LUN ID ========================================="

#import de module
Write-Host "`nImportando o modulo do PowerCli"
Import-Module VMware.VimAutomation.Core -ErrorAction SilentlyContinue

Write-Host "`n`n =================================== Captura de informações =================================== " -ForegroundColor Green

$vcenter = Read-Host "Insira o nome do VCenter para se conectar"
$senhaVMware = Get-Credential -Message "Insira usuario e senha para acesso ao VMware"
$vmCluster = Read-Host "Informe o nome do Cluster para a coleta das informações"

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

$hoje = Get-Date -Format "dd-MM-yyyy-HH_mm"
$VMHosts = @()
$useLunIDs = @()
$wwns = "c:\temp\$($clusterName)_WWNs_$($hoje).csv"
$lunIds = "c:\temp\$($clusterName)_LunIDs_$($hoje).csv"

"VMHost;Device;WWN;Status" | Out-File $wwns
"LUN IDs Disponiveis" | Out-File $lunIds

$maxLuns = 0
foreach ($VMHost in $(Get-Cluster $vmCluster | Get-VMHost | Where-Object PowerState -EQ "PoweredOn")){

    Write-Host ("{0}:" -f $VMHost.Name) -ForegroundColor Green
    Write-Host ">> WWNs:"
    $HBAs = Get-VMHostHba -VMHost $VMHost -Type FibreChannel | Select-Object VMHost,Device,@{N="WWN";E={"{0:X}" -f $_.PortWorldWideName}},Status ### | Where-Object {$_.Status -eq "online"}
    $VMHosts += $HBAs
    $HBAs | ForEach-Object { (" {0} ({1}):  {2}" -f $_.Device, $_.Status, $($_.WWN -replace '..(?!$)', '$&:')) }
    $HBAs | ForEach-Object { ("{0};{1};{2};{3}" -f $_.VMHost, $_.Device, $($_.WWN -replace '..(?!$)', '$&:'), $_.Status) | Out-File $wwns -Append}

    #$useLunIDs += $VMHost | Get-ScsiLun -LunType disk | Select-Object -ExpandProperty runtimename | ForEach-Object { $_.-split(":")[3].Substring(1) }

    $esxCli = Get-EsxCli -VMHost $VMHost
    if (([Version]$esxCli.VMHost.Version).Major -lt 6){
        $maxLuns = 255
        $useLunIDs += $VMHost | Get-ScsiLun -LunType disk | Select-Object -ExpandProperty runtimename | ForEach-Object { $_.-split(":")[3].Substring(1) }
    }else{
        $maxLuns = 512
        $useLunIDs += $esxCli.VMHost.ExtensionData.Config.StorageDevice.MultipathInfo.Lun | ForEach-Object { $_.Path[0].Name.-split('L')[1] }
    }
    Write-Host ""
}

#Removendo as repetidas
$useLunIDs = $useLunIDs | Select-Object -Unique

$freeLunIDs = @()
for ($i = 1; $i -le $maxLuns; $i++){
    if ($($useLunIDs | Where-Object { $_ -eq $i }).Count -gt 0 ){
        continue
    }else{
        $freeLunIDs += $i
        $i | Out-File $lunIds -Append
    }
}

Write-Host "Lun IDs Disponveis: " -ForegroundColor Green
Write-Host $freeLunIDs
Write-Host "`nArquivos gerados: " -ForegroundColor Green
Write-Host "c:\temp\$($clusterName)_WWNs_$($hoje).csv"
Write-Host "c:\temp\$($clusterName)_LunIDs_$($hoje).csv"

Pause