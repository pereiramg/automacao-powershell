<#
    Objetivo: Ativação do firewall Domain, Private, Public
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>

Write-Host -ForegroundColor Green "`n`n========================================= Ativação do firewall Domain, Private, Public =========================================`n`n"

# Solicitando o arquivo com os servidores
$entradaServidores = Get-Content (Read-Host "Insira o caminho e o nome do txt com os servidores: Ex: c:\temp\servidores.txt")

#Credenciais de acesso aos servidores
$acessoServidores = Get-Credential -Message "Insira as credencias de acesso aos servidores"

Invoke-Command -ComputerName $entradaServidores -Credential $acessoServidores -ScriptBlock {
    Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True
}

pause