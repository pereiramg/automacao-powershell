<#
    Objetivo: Forca os updates pendentes no servidor
    Version: 1.0
    Origem: https://timmyit.com/2016/08/01/sccm-and-powershell-force-install-of-software-updates-thats-available-on-client-through-wmi/
    Modificado: Marcelo Galdino Pereira
#>

Write-Host -ForegroundColor Green "========================================= Forca os updates pendentes no servidor ========================================="

#Importando o modulo para validação
Import-Module "$PSScriptRoot\..\winrm\TesteWinRM.ps1" -Force

# Solicitando o arquivo com os servidores
$entradaServidores = Get-Content (Read-Host "Insira o caminho e o nome do txt com os servidores: Ex: c:\temp\servidores.txt")

#Credenciais de acesso aos servidores
$acessoServidores = Get-Credential -Message "Insira as credencias de acesso aos servidores"
$user = $acessoServidores.UserName.ToUpper().Split("\")[-1]

#Execução do teste de conectividade com o POwershell
Write-Host -ForegroundColor Green "`n========================================= Validacao da porta WinRM ========================================="
testWinRM $entradaServidores $user

$data = Get-Date -Format "ddmmyyyy"
if (Test-Path "$PSScriptRoot\..\logs\$($user)ServerAccept-$($data).txt") {
    $servidoresOK = Get-Content "$PSScriptRoot\..\logs\$($user)ServerAccept-$($data).txt"
    Write-Host -ForegroundColor Green "`nOs servidores que fecharam com sucesso:"
    $servidoresOK
}
else {
    Write-Host -ForegroundColor Red "`nNenhum servidor fechou com sucesso a conectividade com o WinRM"
    Pause
    Break
}

Write-Host -ForegroundColor Green "`n========================================= Executando as alteracoes ========================================="

#Definição de variaveis
$appEvalState0 = "0"
$appEvalState1 = "1"
$appEvalState13 = "13"
$applicationClass = [WmiClass]"root\ccm\ClientSDK:CCM_SoftwareUpdatesManager"

<#
    Para conhecimento
    Value   State
    0       ciJobStateNone
    1       ciJobStateAvailable
    13      ciJobStateError

    Todos os codigos do EvaluationState
    https://docs.microsoft.com/en-us/mem/configmgr/develop/reference/core/clients/sdk/ccm_softwareupdate-client-wmi-class
#>


foreach ($servidor in $servidoresOK) {
    $comandoExecucao = (Get-WmiObject -Namespace "root\ccm\clientSDK" -Class CCM_SoftwareUpdate -ComputerName $servidor -Credential $acessoServidores `
    | Where-Object {$_.EvaluationState -like "*$($appEvalState0)*" -or $_.EvaluationState -like "*$($appEvalState1)*" -or $_.EvaluationState -like "*$($appEvalState13)*"})
    Invoke-WmiMethod -Class CCM_SoftwareUpdatesManager -Name InstallUpdates -ArgumentList (,$comandoExecucao) -Namespace root\ccm\clientSDK `
    -ComputerName $servidor -Credential $acessoServidores
}

Write-Host -ForegroundColor Green "`nRealizado o start dos updates nos servidores informados"

Pause