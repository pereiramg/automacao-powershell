<#
    Objetivo: Reiniciar Servidores
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>

Write-Host -ForegroundColor Green "========================================= Reiniciar Servidores ========================================="

# Solicitando o arquivo com os servidores
$entradaServidores = Get-Content (Read-Host "Insira o caminho e o nome do txt com os servidores: Ex: c:\temp\servidores.txt")

#Credenciais de acesso aos servidores
$acessoServidores = Get-Credential -Message "Insira as credencias de acesso aos servidores"

Write-Host -ForegroundColor Green "`n========================================= Executando as alteracoes ========================================="
ForEach ($servidor in $entradaServidores){
    Restart-Computer -ComputerName $servidor -Credential $acessoServidores -Force
}

Write-Host -ForegroundColor Green "`nServidores reiniciados`n"

Pause