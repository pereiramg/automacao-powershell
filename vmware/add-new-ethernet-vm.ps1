<#
    Objetivo: Adicionar uma nova interface de rede
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>


Write-Host "`n`n =================================== Adicionar uma nova interface de rede =================================== " -ForegroundColor Green

#import de module
Write-Host "`nImportando o modulo do PowerCli"
Import-Module VMware.VimAutomation.Core -ErrorAction SilentlyContinue

Write-Host "`n`n =================================== Captura de informações =================================== " -ForegroundColor Green

$csv_input = Read-Host "Insira o caminho do arquivo CSV com os dados dos servidores"
$csv_info = Import-Csv $csv_input -UseCulture
$senhaVMware = Get-Credential -Message "Insira usuario e senha para acesso ao VMware"
$senhaVM = Get-Credential -Message "Insira o usuário e senha do servidor"



foreach ($line in $csv_info){
    #captura das informações do csv
    $Vcenter = $line.Vcenter
    $nameVM = $line.VM_Name
    $vlanBK = $line.vlanBK
    $Vcluster = $line.Cluster
    $ipBK = $line.IPBackup
    $maskBK = $line.maskBackup


    Write-Host "`n`n=================== Conectando no $Vcenter =======================`n`n"
    do{
        try{
            Connect-VIServer $Vcenter -Credential $senhaVMware -Force
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

    #Validando se a $vlanBK existe
    Write-Host "`n===============Validando se a $vlanBK existe=================" -ForegroundColor Green
    $testVLAN = Get-VMHost -Location $Vcluster | Get-VirtualPortGroup -Name $vlanBK -ErrorAction SilentlyContinue
    if ($testVLAN -like ""){
        Write-Host "A VLAN $vlanBK não existe, indo para o proximo da lista" -ForegroundColor Yellow
        sleep 2
        break
    }

    #Adicionando a interface de rede BK no servidor
    Write-Host "Adicionando a interface de rede" -ForegroundColor Green
    $codeBK = @"
    netsh interface ipv4 set address Ethernet2 static $ipBK $maskBK
    netsh interface set interface name = Ethernet2 newname = BACKUP
"@

    Invoke-VMScript -VM $nameVM -GuestCredential $senhaVM -ScriptText $codeBK
    if($Error.Count -ne 0){
        Write-Host "Não foi possivel configurar o IP de backup no $nameVM" -ForegroundColor Yellow
        $Error.Clear()
    }

    #Desconectando do VCenter
    Write-Host "Desconectando do $Vcenter" -ForegroundColor Green
    Disconnect-VIServer -Name $Vcenter -Confirm:$false -ErrorAction SilentlyContinue
}

