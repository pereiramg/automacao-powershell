<#
    Objetivo: Transferencia de arquivos para um datastore
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>


Write-Host "`n`n =================================== Transferencia de arquivos para um datastore =================================== " -ForegroundColor Green

#import de module
Write-Host "`nImportando o modulo do PowerCli"
Import-Module VMware.VimAutomation.Core -ErrorAction SilentlyContinue

Write-Host "`n`n =================================== Captura de informações =================================== " -ForegroundColor Green

$vcenter = Read-Host "Insira o nome do VCenter para se conectar"
$senhaVMware = Get-Credential -Message "Insira usuario e senha para acesso ao VMware"
$fileName = Read-Host "Insira o caminho e o nome do arquivo para transferencia. Ex.: C:\temp\iso\w2k12.iso"
$nameDatastore = Read-Host "Insira o nome do Datastore onde será transferido"
$destFolder = Read-Host "Insira o nome da pasta onde o arqvuivo será transferido"

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

    $datastore = Get-Datastore $nameDatastore

    New-PSDrive -Location $datastore -Name ds -PSProvider VimDatastore -Root "\"

    if(!(Test-Path -Path "DS:/$($destFolder)")){
        New-Item -ItemType Directory -Path "DS:/$($destFolder)" > $null
    }
    Copy-DatastoreItem -Item $fileName -Destination "DS:/$($destFolder)"

    Remove-PSDrive -Name ds -Confirm:$false
    
