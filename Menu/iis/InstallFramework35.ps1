<#
    Objetivo: Instalação do Windows .net Framework 3.5
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>

Write-Host -ForegroundColor Green "========================================= Instalação do Windows .net Framework 3.5 ========================================="

#Importando o modulo para validação
Import-Module "$PSScriptRoot\..\winrm\TesteWinRM.ps1" -Force

# Solicitando o arquivo com os servidores
$entradaServidores = Get-Content (Read-Host "Insira o caminho e o nome do txt com os servidores: Ex: c:\temp\servidores.txt ")

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

$folderSxs = Read-Host "`nInforme o caminho da pasta SXS para instalação"

Invoke-Command -ComputerName $servidoresOK -Credential $acessoServidores -ScriptBlock {
    $valida = Get-WindowsFeature | Where-Object {$_.Name -eq "NET-Framework-Core"}
    if (!$valida){
        install_WindowsFeature NET-Framework-Core -Source $Using:folderSxs folderSxs
    }
}
pause