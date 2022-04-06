<#
    Objetivo: Instalando o rewrite_amd64_en-US.msi
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>

Write-Host -ForegroundColor Green "========================================= Instalando o rewrite_amd64_en-US.msi ========================================="

# Solicitando o arquivo com os servidores
$entradaServidores = Get-Content (Read-Host "Insira o caminho e o nome do txt com os servidores: Ex: c:\temp\servidores.txt")

#Credenciais de acesso aos servidores
$acessoServidores = Get-Credential -Message "Insira as credencias de acesso aos servidores"

Write-Host -ForegroundColor Green "`n========================================= Executando as alteracoes ========================================="
Invoke-Command -ComputerName $entradaServidores -Credential $acessoServidores -ScriptBlock{

    Write-Host "================= Instalando o rewrite_amd64_en-US.msi no $Using:entradaServidores ====================" -ForegroundColor Green

    $logFile = "c:\temp\rewrite_amd64_en-US.log"
    Start-Process msiexec.exe -ArgumentList ('/i c:\temp\rewrite_amd64_en-US.msi AGREETOLICENSE=yes /quiet') -Wait -PassThru | Out-File $logFile -Append
}
