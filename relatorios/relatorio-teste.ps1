<#
    Objetivo: Relatorio CS
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>

Write-Host -ForegroundColor Green "`n`n========================================= Relatorio CS =========================================`n`n"

$servidores = Get-Content "c:\temp\servidores.txt"

$resultado = Invoke-Command -ComputerName $servidores -ScriptBlock {
    Get-ChildItem $env:NUANCE_DATA_DIR -Recurse *.* -File | Select-String "ENV=NLEinnd|KEYS(0)=<INTENT>" -AllMatches |
    ForEach-Object{$_.line.split("|")[3]} | ForEach-Object{($_ -split('<INTENT'))[1]} | ForEach-Object{($_ -split('</INTENT'))[0]} | Where-Object{$_}
}

#Tratando o resultado
$resultado = $resultado | Group-Object | Select-Object -Property Count,Name | Sort-Object Count -Descending

# Gerando o relatorio
Write-Information $resultado

#Exibindo na tela o resultado
Write-Output $resultado

Pause