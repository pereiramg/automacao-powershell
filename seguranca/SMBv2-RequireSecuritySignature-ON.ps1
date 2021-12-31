<#
    Objetivo: SMBv2 Require Security Signature ON
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>

Write-Host -ForegroundColor Green "`n`n========================================= SMBv2 Require Security Signature ON =========================================`n`n"

# Solicitando o arquivo com os servidores
$entradaServidores = Get-Content (Read-Host "Insira o caminho e o nome do txt com os servidores: Ex: c:\temp\servidores.txt")

#Credenciais de acesso aos servidores
$acessoServidores = Get-Credential -Message "Insira as credencias de acesso aos servidores"

Write-Host -ForegroundColor Green "`n========================================= Executando as alteracoes ========================================="

Invoke-Command -ComputerName $entradaServidores -Credential $acessoServidores -ScriptBlock {
    #Valores e Keys
    $requireSecuritySignature = "RequireSecuritySignature"
    $requireValue = "1"

    #Alteração do valor
    $lanmanServerSMVv2 = (Get-Item HKLM:\).OpenSubKey("SYSTEM", $true).CreateSubKey("CurrentControlSet\Services\LanmanServer\Parameters")
    $lanmanServerSMVv2.SetValue($requireSecuritySignature, $requireValue, [Microsoft.Win32.RegistryValueKind]::DWord)

    $lanmanWorkstationSMVv2 = (Get-Item HKLM:\).OpenSubKey("SYSTEM", $true).CreateSubKey("CurrentControlSet\Services\LanmanWorkstation\Parameters")
    $lanmanWorkstationSMVv2.SetValue($requireSecuritySignature, $requireValue, [Microsoft.Win32.RegistryValueKind]::DWord)
}

Write-Host "Executado nos servidores com sucesso"

Pause