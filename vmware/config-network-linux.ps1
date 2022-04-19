<#
    Objetivo: Configurações de IPs-Linux
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>

Write-Host -ForegroundColor Green "========================================= Configurações de IPs-Linux ========================================="

#import de module
Write-Host "`nImportando o modulo do PowerCli"
Import-Module VMware.VimAutomation.Core -ErrorAction SilentlyContinue

Write-Host "`n`n =================================== Captura de informações =================================== " -ForegroundColor Green

$csv_input = Read-Host "Insira o caminho do arquivo CSV com os dados dos servidores"
$csv_info = Import-Csv $csv_input -UseCulture
$senhaVMware = Get-Credential -Message "Insira usuario e senha para acesso ao VMware"
$senhaVMLinux = Get-Credential -Message "Insira o usuário e senha do servidor Linux"
$file_script_linux_sh = "$PSScriptRoot\config-ip-linux.sh"

foreach ($line in $csv_info){
    #captura das informações do csv
    $Vcenter = $line.Vcenter
    $nameVM = $line.VM_Name

    $setIP = $line.IP
    $setIp = $setIP.Trim()

    $setMask = $line.Mask
    $setMask = $setMask.Trim()

    $setGateway = $line.DefaulGateway
    $setGateway = $setGateway.Trim()

    #$netAdpt = "Network Adapter 1"

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

    #Execução
    $vmNameLinux = $nameVM.toLower()
    $config_network = "$vmNameLinux;$setIP;$setMask;$setGateway"
    $script_config = "cd /root && echo '$config_network' > lista_ip.txt && chmod 750 ./config-ip-linux.sh && ./config-ip-linux.sh"

    #Validando o arquivo sh
    $test_script_linux_sh = Get-Item $file_script_linux_sh
    if($test_script_linux_sh -like ""){
        Write-Host "O arquivo $file_script_linux_sh não foi localizado" -ForegroundColor Yellow
    }else {
        Write-Host "`n=============Executando as configurações no $nameVM =============" -ForegroundColor Green
        $Error.Clear()
        Copy-VMGuestFile -Source $file_script_linux_sh -Destination "/root/" -VM $nameVM -LocalToGuest -GuestCredential $senhaVMLinux
        if($Error.Count -eq 0){
            $Error.Clear()
            Invoke-VMScript -VM $nameVM -GuestCredential $senhaVMLinux -ScriptText $script_config
            Invoke-VMScript -VM $nameVM -GuestCredential $senhaVMLinux -ScriptText "rm /root/config-ip-linux.sh"
            Invoke-VMScript -VM $nameVM -GuestCredential $senhaVMLinux -ScriptText "/sbin/ifconfig -a"
            if($Error.Count -ne 0){
                Write-Host "Não foi possivel copiar o arquivo para o servidor $nameVM" -ForegroundColor Yellow
            }
        }else {
            Write-Host "Não foi possivel copiar o arquivo para o servidor $nameVM" -ForegroundColor Yellow
        }
    }
    #Desconectando do VCenter
    Write-Host "Desconectando do $Vcenter" -ForegroundColor Green
    Disconnect-VIServer -Name $Vcenter -Confirm:$false -ErrorAction SilentlyContinue
}
