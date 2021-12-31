<#
    Objetivo: Criação de grupos no AD
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>

Write-Host -ForegroundColor Green "========================================= Criação de grupos no AD ========================================="

#Captura as informações dos nomes a serem criados em um txt
$txtNomes = Read-Host "Informe o caminho do txt com os nomes a serem criados "

$txtNomes = Get-Content $txtNomes

foreach ($nome in $txtNomes) {
    New-ADGroup -Name "G_$($nome)_teste" -SamAccountName "G_$($nome)_teste" -GroupCategory Security `
    -GroupScope Global -DisplayName "G_$($nome)_teste" -Path "OU=Groups,OU=Principal,DC=Dominio,DC=com,DC=corp"
}

Write-Host -ForegroundColor Green "Criado com sucesso os grupos"

Pause