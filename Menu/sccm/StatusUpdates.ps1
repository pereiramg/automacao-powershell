<#
    Objetivo: Verificar o status dos updates nos servidores
    Version: 1.0
    Origem: https://timmyit.com/2016/08/01/sccm-and-powershell-force-install-of-software-updates-thats-available-on-client-through-wmi/
    Modificado: Marcelo Galdino Pereira
#>

Write-Host -ForegroundColor Green "========================================= Verificar o status dos updates nos servidores ========================================="

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
$appEvalState2 = "2"
$appEvalState3 = "3"
$appEvalState4 = "4"
$appEvalState5 = "5"
$appEvalState6 = "6"
$appEvalState7 = "7"
$appEvalState8 = "8"
$appEvalState9 = "9"
$appEvalState10 = "10"
$appEvalState11 = "11"
$appEvalState12 = "12"
$appEvalState13 = "13"

<#
    Para conhecimento
    Value   State
    0       ciJobStateNone
    1       ciJobStateAvailable
    2       ciJobStateSubmitted
    3       ciJobStateDetecting
    4       ciJobStatePreDownload
    5       ciJobStateDownloading
    6       ciJobStateWaitInstall
    7       ciJobStateInstall
    13      ciJobStateError

    Todos os codigos do EvaluationState
    https://docs.microsoft.com/en-us/mem/configmgr/develop/reference/core/clients/sdk/ccm_softwareupdate-client-wmi-class
#>

foreach ($server in $servidoresOK) {

    $application = Get-WmiObject -Namespace "root\ccm\clientSDK" -Class CCM_SoftwareUpdate -ComputerName $server -Credential $acessoServidores

    if (!$application) {
        Write-Output "$server - Nenhum Update Pendente" | Tee-Object -Append "$PSScriptRoot\..\logs\$($user)_Status_Updates$($data).txt"
    }

    #ciJobStateNone
    if ($application.EvaluationState -eq $appEvalState0 ) {
        Write-Output "$server - Updates Pendentes" | Tee-Object -Append "$PSScriptRoot\..\logs\$($user)_Status_Updates$($data).txt"
    }

    #ciJobStateAvailable
    if ($application.EvaluationState -eq $appEvalState1 ) {
        Write-Output "$server - Updates Pendentes" | Tee-Object -Append "$PSScriptRoot\..\logs\$($user)_Status_Updates$($data).txt"
    }
    
    #ciJobStateDownloading
    if ($application.EvaluationState -eq $appEvalState5 ) {
        Write-Output "$server - Processo de download de updates" | Tee-Object -Append "$PSScriptRoot\..\logs\$($user)_Status_Updates$($data).txt"
    }

    #ciJobStateInstall
    if ($application.EvaluationState -eq $appEvalState7 ) {
        Write-Output "$server - Sem Updates Pendentes" | Tee-Object -Append "$PSScriptRoot\..\logs\$($user)_Status_Updates$($data).txt"
    }

    #ciJobStatePendingSoftReboot
    if ($application.EvaluationState -eq $appEvalState8 ) {
        Write-Output "$server - Pendente boot" | Tee-Object -Append "$PSScriptRoot\..\logs\$($user)_Status_Updates$($data).txt"
    }

    #ciJobStatePendingHardReboot
    if ($application.EvaluationState -eq $appEvalState9 ) {
        Write-Output "$server - Updates Pendentes" | Tee-Object -Append "$PSScriptRoot\..\logs\$($user)_Status_Updates$($data).txt"
    }

    #ciJobStateError
    if ($application.EvaluationState -eq $appEvalState13 ) {
        Write-Output "$server - Erro na instalacao dos updates" | Tee-Object -Append "$PSScriptRoot\..\logs\$($user)_Status_Updates$($data).txt"
    }
}

Write-Host -ForegroundColor Green "`n`n O arquivo foi gerado no caminho $PSScriptRoot\..\logs\$($user)_Status_Updates$($data).txt"

Pause