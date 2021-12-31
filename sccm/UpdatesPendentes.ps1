<#
    Objetivo: Updates Pendentes
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>

Write-Host -ForegroundColor Green "========================================= Updates Pendentes ========================================="

# Solicitando o arquivo com os servidores
$entradaServidores = Get-Content (Read-Host "Insira o caminho e o nome do txt com os servidores: Ex: c:\temp\servidores.txt")

#Credenciais de acesso aos servidores
$acessoServidores = Get-Credential -Message "Insira as credencias de acesso aos servidores"

$data = Get-Date -Format "ddmmyyyy"

Write-Host -ForegroundColor Green "`n========================================= Executando as alteracoes ========================================="

$resultado = Invoke-Command -ComputerName $entradaServidores -Credential $acessoServidores -ScriptBlock {
    $patchsPendentes = Get-WmiObject -Query "Select * from CCM_UpdateStatus" -Namespace "root\ccm\SoftwareUpdates\UpdatesStore" | `
        Where-Object { ($_.Status -eq "Missing") } | Select-Object Title
    Write-Output "Servidor $env:COMPUTERNAME"
    Write-Output "Total de Updates: " $patchsPendentes.count
    $patchsPendentes
}

$resultado | Tee-Object -Append "c:\temp\ResultadoUpdates$($data).txt"

Write-Host -ForegroundColor Green "`nO arquivo foi gerado com sucesso no caminho: c:\temp\ResultadoUpdates$($data).txt"

Pause