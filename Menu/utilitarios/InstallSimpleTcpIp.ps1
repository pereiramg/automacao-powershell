<#
    Objetivo: Instalação do Simple TCP/IP Services no Windows Server
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>

Write-Host -ForegroundColor Green "========================================= Instalacao do Simple TCP/IP Services no Windows Server ========================================="

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
if (Test-Path "$PSScriptRoot\..\logs\$($user)ServerAccept-$($data).txt"){
    $servidoresOK = Get-Content "$PSScriptRoot\..\logs\$($user)ServerAccept-$($data).txt"
    Write-Host -ForegroundColor Green "`nOs servidores que fecharam com sucesso:"
    $servidoresOK
}else{
    Write-Host -ForegroundColor Red "`nNenhum servidor fechou com sucesso a conectividade com o WinRM"
    Pause
    Break
}

Write-Host -ForegroundColor Green "`n========================================= Executando as alteracoes ========================================="
Invoke-Command -ComputerName $servidoresOK -Credential $acessoServidores -ScriptBlock{
    $valida = Get-windowsFeature | Where-Object {$_.Name -eq "Simple-TCPIP"}
    IF ($valida -ne "True"){
        Install-WindowsFeature Simple-TCPIP
    }
} # fim invoke command

#Resultado da instalação nos servidores
$resultado = Invoke-Command -ComputerName $servidoresOK -Credential $acessoServidores -ScriptBlock{
    Get-WindowsFeature -Name Simple-TCPIP
}

$resultado
Pause