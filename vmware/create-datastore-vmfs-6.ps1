<#
    Objetivo: Criação de datastorage VMFS 6
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>

echo "`n`n==================================== Criacao de datastorage VMFS 6 ============================================`n`n"

#import de module
Write-Host "`nImportando o modulo do PowerCli"
Import-Module VMware.VimAutomation.Core -ErrorAction SilentlyContinue

Write-Host "`n`n =================================== Captura de informações =================================== " -ForegroundColor Green

$vcenter = Read-Host "Insira o nome do VCenter para se conectar"
$esxiServer = Read-Host "Insira o nome do ESxi dentro do cluster na qual deseja adicionar o Datastorage"
$senhaVMware = Get-Credential -Message "Insira usuario e senha para acesso ao VMware"

$csv_input = Read-Host "Insira o caminho do arquivo CSV com o nome e naa dos storages"
$csv_info = Import-Csv $csv_input -UseCulture

$hoje = Get-Date -Format "dd-MM-yyyy"
Start-Transcript -Path "$PSScriptRoot\create-datastore-vmfs-6-$($hoje).log" -Append

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

    if ($Global:DefaultVIServers -ne $null){
        Write-Host "Conectado com sucesso no $vcenter"
    }else{
        Write-Host "Não foi possivel se conectar, verificar..." -ForegroundColor Yellow
        exit
    }

    foreach ($line in $csv_info){

        #Captura os campos do CSV
        $datastoreName = $line.Datastore_name
        $datastoreName = $datastoreName.Trim()

        $naaId = $line.Naa_ID
        $naaId = $naaId.Trim()

        New-Datastore -VMHost $esxiServer -Name $datastoreName -Path $naaId -Vmfs -FileSystemVersion 6
    }

    foreach ($line in $csv_info){
        $datastoreName = $line.Datastore_name
        $datastoreName = $datastoreName.Trim()
        Get-VMHost -Name $esxiServer | Get-Datastore -Name $datastoreName | Select-Object Name
    }
    
Stop-Transcript
Pause