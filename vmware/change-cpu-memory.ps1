<#
    Objetivo: Ajustar CPU e Memoria dos servidores
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>


Write-Host -ForegroundColor Green "========================================= Ajustar CPU e Memoria dos servidores ========================================="

#import de module
Write-Host "`nImportando o modulo do PowerCli"
Import-Module VMware.VimAutomation.Core -ErrorAction SilentlyContinue

Write-Host "`n`n =================================== Captura de informações =================================== " -ForegroundColor Green

$csv_input = Read-Host "Insira o caminho do arquivo CSV com os dados dos servidores"
$csv_info = Import-Csv $csv_input -UseCulture
$senhaVMware = Get-Credential -Message "Insira usuario e senha para acesso ao VMware"

foreach ($line in $csv_info){
    #Capturando os dados do CSV
    $vcenterName = $line.Vcenter
    $vcenterName = $vcenterName.Trim()

    $newName = ($line.VM_Name).toUpper()
    $newName = $newName.Trim()

    $newCPU = $line.newCPU
    $newMemory = $line.newMemory

    Write-Host "`n`n=================== Conectando no $vcenterName =======================`n`n"
    do{
        try{
            Connect-VIServer $vcenterName -Credential $senha_vmware -Force
        }catch [System.ServiceModel.Security.SecurityNegotiationException]{
            Write-Host "Realizando nova tentativa de conexão" -ForegroundColor Yellow
        }

        try{
            $lasterror = [string]$Error[0].Exception.GetType().FullName
        }catch [System.Management.Automation.RuntimeException]{
            $lasterror = " "
        }$Error.Clear()
    }until( $lasterror -ne "System.ServiceModel.Security.SecurityNegotiationException")

    Write-Host "Conectado com sucesso no $vcenterName"

    #Desligando a VM
    Write-Host "Desligando a $newName" -ForegroundColor Green
    Stop-VM $newName -Confirm:$false

    #Validando se o servidor desligou
    do{
        Write-Host "Servidor ainda ligado, aguarde um momento" -ForegroundColor Green
        Start-Sleep 2
    }while((Get-VM $newName | Select-Object PowerState -ExpandProperty PowerState) -eq "PoweredOn")

    #Ajustando o tamanho de CPU e Memoria
    Get-VM $newName | Set-VM -MemoryGB $newMemory -NumCpu $newCPU -Confirm:$false

    #Ligando a VM
    Write-Host "`nLigando a $newName" -ForegroundColor Green
    Start-VM $newName -Confirm:$false
    Disconnect-VIServer $vcenterName
}
