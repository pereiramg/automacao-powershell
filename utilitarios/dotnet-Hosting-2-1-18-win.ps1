<#
    Objetivo: Instalando o dotNet-Hosting-2-1-18-win.exe
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>

Write-Host -ForegroundColor Green "========================================= Instalando o dotNet-Hosting-2-1-18-win.exe ========================================="

# Solicitando o arquivo com os servidores
$entradaServidores = Get-Content (Read-Host "Insira o caminho e o nome do txt com os servidores: Ex: c:\temp\servidores.txt")

#Credenciais de acesso aos servidores
$acessoServidores = Get-Credential -Message "Insira as credencias de acesso aos servidores"

Write-Host -ForegroundColor Green "`n========================================= Executando a Instalação do dotNet-Hosting-2-1-18-win.exe ========================================="
Invoke-Command -ComputerName $entradaServidores -Credential $acessoServidores -ScriptBlock{

    Write-Host "================= Instalando o dotNet-Hosting-2-1-18-win.exe no $Using:entradaServidores ====================" -ForegroundColor Green

    $logFile = "c:\temp\dotNet-Hosting-2-1-18-win.exe.log"
    Start-Process -FilePath "C:\temp\dotNet-Hosting-2-1-18-win.exe" -ArgumentList "/silent AGREETOLICENSE=yes" -Wait -PassThru | Out-File $logFile -Append
}
