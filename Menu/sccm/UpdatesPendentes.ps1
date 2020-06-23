<#
    Objetivo: Updates Pendentes
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>

Write-Host -ForegroundColor Green "========================================= Updates Pendentes ========================================="

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

$resultado = Invoke-Command -ComputerName $servidoresOK -Credential $acessoServidores -ScriptBlock {
    $patchsPendentes = Get-WmiObject -Query "Select * from CCM_UpdateStatus" -Namespace "root\ccm\SoftwareUpdates\UpdatesStore" | `
        Where-Object { ($_.Status -eq "Missing") } | Select-Object Title
    Write-Output "Servidor $env:COMPUTERNAME"
    Write-Output "Total de Updates: " $patchsPendentes.count
    $patchsPendentes
}

$resultado | Tee-Object -Append "$PSScriptRoot\..\logs\$($user)ResultadoUpdates$($data).txt"

Write-Host -ForegroundColor Green "`nO arquivo foi gerado com sucesso no caminho: $PSScriptRoot\..\logs\$($user)ResultadoUpdates$($data).txt"

Pause