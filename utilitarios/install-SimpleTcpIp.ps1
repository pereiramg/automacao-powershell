<#
    Objetivo: Instalação do Simple TCP/IP Services no Windows Server
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>

Write-Host -ForegroundColor Green "========================================= Instalacao do Simple TCP/IP Services no Windows Server ========================================="

# Solicitando o arquivo com os servidores
$entradaServidores = Get-Content (Read-Host "Insira o caminho e o nome do txt com os servidores: Ex: c:\temp\servidores.txt")

#Credenciais de acesso aos servidores
$acessoServidores = Get-Credential -Message "Insira as credencias de acesso aos servidores"

Write-Host -ForegroundColor Green "`n========================================= Executando as alteracoes ========================================="
Invoke-Command -ComputerName $entradaServidores -Credential $acessoServidores -ScriptBlock{
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