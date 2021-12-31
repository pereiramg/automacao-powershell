<#
    Objetivo: Instalação do Windows .net Framework 3.5
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>

Write-Host -ForegroundColor Green "========================================= Instalacao do Windows .net Framework 3.5 ========================================="

# Solicitando o arquivo com os servidores
$entradaServidores = Get-Content (Read-Host "Insira o caminho e o nome do txt com os servidores: Ex: c:\temp\servidores.txt ")

#Credenciais de acesso aos servidores
$acessoServidores = Get-Credential -Message "Insira as credencias de acesso aos servidores"

# Aqui precisamos dos binarios
# Essa pasta pode ser encontrada na ISO de instalação do S.O.
$folderSxs = Read-Host "`nInforme o caminho da pasta SXS para instalacao"

Invoke-Command -ComputerName $entradaServidores -Credential $acessoServidores -ScriptBlock {
    $valida = Get-WindowsFeature | Where-Object {$_.Name -eq "NET-Framework-Core"}
    if ($valida.Installed -ne "True"){
        install-WindowsFeature NET-Framework-Core -Source $Using:folderSxs
    }
}

# Resultado da instalação nos servidores
$resultado = Invoke-Command -ComputerName $entradaServidores -Credential $acessoServidores -ScriptBlock {
    Get-WindowsFeature -Name NET-Framework-Core
}

$resultado | Format-List PSComputerName,DisplayName,Installed

pause