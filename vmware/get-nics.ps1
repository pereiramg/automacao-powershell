<#
    Objetivo: Obter switch e porta de cada ESXi de um cluster
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>

Write-Host -ForegroundColor Green "========================================= Obter switch e porta de cada ESXi de um cluster ========================================="

#import de module
Write-Host "`nImportando o modulo do PowerCli"
Import-Module VMware.VimAutomation.Core -ErrorAction SilentlyContinue

Write-Host "`n`n =================================== Captura de informações =================================== " -ForegroundColor Green

$vcenter = Read-Host "Insira o nome do VCenter para se conectar"
$senhaVMware = Get-Credential -Message "Insira usuario e senha para acesso ao VMware"
$clusterName = Read-Host "Insira o nome do Cluster"


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

if ($Global:DefaultVIServers -ne $null){
    Write-Host "Conectado com sucesso no $vcenter"
}else{
    Write-Host "Não foi possivel se conectar, verificar..." -ForegroundColor Yellow
    exit
}

Write-Host "`n`n =================================== Iniciando a coleta das informação no $clusterName =================================== " -ForegroundColor Green

foreach ($vmhost in $(Get-Cluster -Name $clusterName | Get-VMHost <#| Where-Object {$_.ConnectionState -eq "Connected"}#> )){

    $hostNicQuery = Get-View $vmhost.ExtensionData.ConfigManager.NetworkSystem
    $physicalNic = $hostNicQuery.NetworkInfo.Pnic

    foreach ($pNic in $physicalNic){
        $pNicCdpInfo = $hostNicQuery.QueryNetworkHint($pNic.Device)

        #Valida se o ConnectedSwitchPort está Conectado
        if ($pNicCdpInfo.ConnectedSwitchPort){
            $connected = $true
        }else{
            $connected = $false
            continue
        }
        Write-Host -ForegroundColor Green $pNic.Device
        foreach ($switchInfo in $pNicCdpInfo){
            #if ([String]::IsNullOrEmpty($switchInfo.ConnectedSwitchPort.PortId)){ continue }
            $objectNicCDP = "" | Select-Object Cluster, VMHost, HostNIC, NICMacAddr, Connected, SwitchName, HardwarePlatform, SoftwareVersion, SwitchMangementAddress, SwitchPortId

            $objectNicCDP.Cluster = $vmhost.Parent
            $objectNicCDP.VMHost = $vmhost.Name
            $objectNicCDP.HostNIC = $pNic.Device
            $objectNicCDP.NICMacAddr = $pNic.Mac
            $objectNicCDP.Connected = $connected
            $objectNicCDP.SwitchName = $switchInfo.ConnectedSwitchPort.DevId
            $objectNicCDP.HardwarePlatform = $switchInfo.ConnectedSwitchPort.HardwarePlatform
            $objectNicCDP.SoftwareVersion = $switchInfo.ConnectedSwitchPort.SoftwareVersion
            $objectNicCDP.SwitchMangementAddress = $switchInfo.ConnectedSwitchPort.MgmtAddr
            $objectNicCDP.SwitchPortId = $switchInfo.ConnectedSwitchPort.PortId
            $objectNicCDP
            $objectNicCDP | Export-Csv -Append -NoClobber -NoTypeInformation -Delimiter ";" -Path "C:\Temp\$("{0}_allnics_{1}.csv" -f $vmhost.Parent,$senhaVMware.UserName.ToUpper().Split("\")[-1])"
        }
    }
}

Write-Host "`nO log foi gravado no caminho abaixo: `n"
Write-Host "C:\Temp\$("{0}_allnics_{1}.csv" -f $vmhost.Parent,$senhaVMware.UserName.ToUpper().Split("\")[-1])"


Pause