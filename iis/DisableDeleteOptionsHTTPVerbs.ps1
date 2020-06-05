<#
    Objetivo: Disable o Delete e Options no HTTP Verbs IIS
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>

Write-Host -ForegroundColor Green "========================================= Disable o Delete e Options no HTTP Verbs IIS ========================================="

#Importando o modulo para validação
Import-Module "$PSScriptRoot\..\winrm\TesteWinRM.ps1" -Force

# Solicitando o arquivo com os servidores
$entradaServidores = Read-Host "Insira o caminho e o nome do txt com os servidores: Ex: c:\temp\servidores.txt "

# Pegando o conteudo para tratamento
$entradaServidores = Get-Content $entradaServidores

#Credenciais de acesso aos servidores
$acessoServidores = Get-Credential -Message "Insira as credencias de acesso aos servidores"
$user = $acessoServidores.UserName.ToUpper().Split("\")[-1]

#Execução do teste de conectividade com o POwershell
Write-Host -ForegroundColor Green "========================================= Validacao da porta WinRM ========================================="
testWinRM $entradaServidores $user

$data = Get-Date -Format "ddmmyyyy"
if (Test-Path "$PSScriptRoot\..\logs\$($user)ServerAccept-$($data).txt"){
    $servidoresOK = Get-Content "$PSScriptRoot\..\logs\$($user)ServerAccept-$($data).txt"
    Write-Host -ForegroundColor Green "`nOs servidores que fecharam com sucesso:"
    $servidoresOK
}else{
    Write-Host -ForegroundColor Red "Nenhum servidor fechou com sucesso a conectividade com o WinRM"
    Pause
    Break
}

Write-Host -ForegroundColor Green "========================================= Executando as alteracoes ========================================="
Invoke-Command -ComputerName $servidoresOK -Credential $acessoServidores -ScriptBlock{
    Add-WebConfigurationProperty -PSPath "MACHINE/WEBROOT/APPHOST" -Filter "system.webServer/security/requestFiltering" -Value @{VERB="OPTIONS";allowed="False"} -Name Verbs -AtIndex 0
    Add-WebConfigurationProperty -PSPath "MACHINE/WEBROOT/APPHOST" -Filter "system.webServer/security/requestFiltering" -Value @{VERB="DELETE";allowed="False"} -Name Verbs -AtIndex 1
}

Pause