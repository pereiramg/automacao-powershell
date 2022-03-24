<#
    Objetivo: Recapacity Disk
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>

Write-Host "`n`n =================================== Recapacity Disk =================================== " -ForegroundColor Green

Write-Host "`nImportando o modulo do PowerCli`n" -ForegroundColor Green
Import-Module VMware.VimAutomation.Core -EA SilentlyContinue

Write-Host "`n`n=================== Captura de informações =================`n`n" -ForegroundColor Green
$csv_input = Read-Host "Insira o caminho com os dados dos servidores e disco"
$csv_info = Import-Csv $csv_input -UseCulture
$senha_vmware = Get-Credential -Message "Insira usuário e senha para acesso ao VMware"

foreach ($line in $csv_info) {
    
    $Vcenter = $line.$Vcenter
    $Vcenter = $Vcenter.Trim()

    $NameVM = ($line.NameVM).toUpper()
    $NameVM = $NameVM.Trim()

    $CapacityGB_New = ($line.$CapacityGB).toUpper()
    $CapacityGB_New = $CapacityGB_New.Trim()

    $Disco = ($line.Disco).toUpper()

    #Criação de logs
    $logs = "$PSScriptRoot\"+$senha_vmware.UserName.ToUpper().Split("\")[-1]
    if (!(Test-Path -Path $logs)){
        New-Item -ItemType Directory -Path $logs}

    $login = $senha_vmware.UserName.ToLower().Split("\")[-1]
    $logs_server = "$logs\$($login)_($NameVM).txt"
    if (!(Test-Path -Path $logs_server)){
        New-Item -Path $logs -Name "$($NameVM).txt" -ItemType File}

    Start-Transcript -Path $logs_server -Append

    Get-Date | Select-Object "DateTime"
    
    #Exibe o conteudo da variavel
    Write-Host ("`r Executando o Script como: $($senha_vmware.UserName)").ToUpper()
    Write-Host "`r"
    Write-Host "`n Vcenter: $Vcenter `r"
    Write-Host "`n Vcenter: $NameVM `r"
    Write-Host "`n Vcenter: $CapacityGB_New `r"
    Write-Host "`n Vcenter: $Disco `r"

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

        Write-Host "`n`n=============== Realizando o aumento do discos do servidor $NameVM ================`n`n"
        Get-VM $NameVM | Get-HardDisk -Name $Disco | Set-HardDisk -CapacityGB $CapacityGB_New -Confirm:$false

        Write-Host "`nDESCONECTANDO DO VCENTER... `r`n" -ForegroundColor Green
        Disconnect-VIServer -Confirm:$false -EA SilentlyContinue

        Stop-Transcript
        Start-Sleep 10
}
