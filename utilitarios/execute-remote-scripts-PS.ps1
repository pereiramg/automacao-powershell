<#
    Objetivo: Execução de scripts Powershell remoto
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>

Write-Host -ForegroundColor Green "`n`n========================================= Execução de scripts Powershell remoto =========================================`n`n"

# Solicitando o arquivo com os servidores
$entradaServidores = Get-Content (Read-Host "Insira o caminho e o nome do txt com os servidores: Ex: c:\temp\servidores.txt ")

#Credenciais de acesso aos servidores
$acessoServidores = Get-Credential -Message "Insira as credencias de acesso aos servidores"

#Captura dos usuarios
Write-Host -ForegroundColor Green "`n========================================= Informe o caminho do PS1 ========================================="
$nomeScriptPS1 = Read-Host "Informe o caminho do script. EX.: c:\temp\Teste.ps1"

Write-Host -ForegroundColor Green "`n========================================= Executando as alteracoes ========================================="
Invoke-Command -ComputerName $entradaServidores -Credential $acessoServidores -FilePath $nomeScriptPS1