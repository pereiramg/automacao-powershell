<#
    Objetivo: Disabilita o Dual Scan 
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>

Write-Host -ForegroundColor Green "`n`n========================================= Disabilita o Dual Scan  =========================================`n`n"

# Solicitando o arquivo com os servidores
$entradaServidores = Get-Content (Read-Host "Insira o caminho e o nome do txt com os servidores para adicionar na Collection: Ex: c:\temp\servidores.txt")

#Credenciais de acesso aos servidores
$acessoServidores = Get-Credential -Message "Insira as credencias de acesso aos servidores"

# Executando as alterações
Invoke-Command -ComputerName $entradaServidores -Credential $acessoServidores -ScriptBlock {
    $dualScan = "DisableDualScan"
    $dualScanDisable = "1"

    $disable = (Get-Item HKLM:\).OpenSubKey("SOFTWARE", $true).CreateSubKey("Policies\Microsoft\Windows\WindowsUpdate")
    $disable.SetValue($dualScan, $dualScanDisable, [Microsoft.Win32.RegistryValueKind]::DWord)
}


Pause