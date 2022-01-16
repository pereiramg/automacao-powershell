<#
    Objetivo: Remover Shares indevidas
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>

Write-Host -ForegroundColor Green "========================================= Remover Shares indevidas ========================================="

# Solicitando o arquivo com os servidores
$entradaServidores = Get-Content (Read-Host "Insira o caminho e o nome do txt com os servidores: Ex: c:\temp\servidores.txt")

#Credenciais de acesso aos servidores
$acessoServidores = Get-Credential -Message "Insira as credencias de acesso aos servidores"

$shares = Read-Host "Informa o nome da share na qual precisa deletar sem o '$': "
$shares += '$'

Write-Host -ForegroundColor Green "`n================================= Iniciando o processo de validação e remoção das shares ======================================="

Invoke-Command -ComputerName $entradaServidores -Credential $acessoServidores -ScriptBlock {
    Remove-FileShare -Name $using:shares -Confirm:$false -ErrorAction SilentlyContinue
}

Write-Host "`nExecutado a remoção da share"

Pause