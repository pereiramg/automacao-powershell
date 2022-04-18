<#
    Objetivo: Captura do MAC Address em servidores Windows
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>


Write-Host "`n`n =================================== Captura do MAC Address em servidores Windows =================================== " -ForegroundColor Green

# Solicitando o arquivo com os servidores
$entradaServidores = Get-Content (Read-Host "Insira o caminho e o nome do txt com os servidores: Ex: c:\temp\servidores.txt ")

#Credenciais de acesso aos servidores
$acessoServidores = Get-Credential -Message "Insira as credencias de acesso aos servidores"

$data = Get-Date -Format "dd-MM-yyyy"

Write-Host "================== Capturando os MAC Address dos servidores Windows ==================" -ForegroundColor Green
$mac_resultado = Invoke-Command -ComputerName $entradaServidores -Credential $acessoServidores -ScriptBlock{
    $mac_address += Get-NetAdapter | Select-Object MacAddress
    Return $mac_address
}

$mac_resultado | Out-File -Append C:\temp\MAC_ADDRESS_$($data).txt
