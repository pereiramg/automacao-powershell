<#
    Objetivo: Deletar Folder ou Files
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>

Write-Host -ForegroundColor Green "========================================= Deletar Folder ou Files ========================================="

# Solicitando o arquivo com os servidores
$entradaServidores = Get-Content (Read-Host "Insira o caminho e o nome do txt com os servidores: Ex: c:\temp\servidores.txt ")

#Credenciais de acesso aos servidores
$acessoServidores = Get-Credential -Message "Insira as credencias de acesso aos servidores"

#Captura dos usuarios
Write-Host -ForegroundColor Green "`n========================================= Informacao do Folder/File ========================================="
$nomeFolderFile = Read-Host "Informe o caminho do arquivo ou pasta para remoção. EX.: c:\temp\Teste"

Write-Host -ForegroundColor Green "`n========================================= Executando as alteracoes ========================================="
Invoke-Command -ComputerName $entradaServidores -Credential $acessoServidores -ScriptBlock {
    Remove-Item -LiteralPath $using:nomeFolderFile -Force -Recurse -ErrorAction Ignore
    Write-Host "Realizado a remoção com sucesso do $using:nomeFolderFile em $env:COMPUTERNAME"
}

Pause