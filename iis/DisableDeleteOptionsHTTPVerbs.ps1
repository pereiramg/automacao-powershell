<#
    Objetivo: Disable o Delete e Options no HTTP Verbs IIS
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>

Write-Host -ForegroundColor Green "========================================= Disable o Delete e Options no HTTP Verbs IIS ========================================="

# Solicitando o arquivo com os servidores
$entradaServidores = Get-Content (Read-Host "Insira o caminho e o nome do txt com os servidores: Ex: c:\temp\servidores.txt ")

#Credenciais de acesso aos servidores
$acessoServidores = Get-Credential -Message "Insira as credencias de acesso aos servidores"

Write-Host -ForegroundColor Green "`n========================================= Executando as alteracoes ========================================="
Invoke-Command -ComputerName $entradaServidores -Credential $acessoServidores -ScriptBlock{
    Add-WebConfigurationProperty -PSPath "MACHINE/WEBROOT/APPHOST" -Filter "system.webServer/security/requestFiltering" -Value @{VERB="OPTIONS";allowed="False"} -Name Verbs -AtIndex 0
    Add-WebConfigurationProperty -PSPath "MACHINE/WEBROOT/APPHOST" -Filter "system.webServer/security/requestFiltering" -Value @{VERB="DELETE";allowed="False"} -Name Verbs -AtIndex 1
}

Pause