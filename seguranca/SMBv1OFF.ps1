<#
    Objetivo: Desabilitar o SMBv1
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>

Write-Host -ForegroundColor Green "========================================= Desabilitar o SMBv1 ========================================="

# Solicitando o arquivo com os servidores
$entradaServidores = Get-Content (Read-Host "Insira o caminho e o nome do txt com os servidores: Ex: c:\temp\servidores.txt")

#Credenciais de acesso aos servidores
$acessoServidores = Get-Credential -Message "Insira as credencias de acesso aos servidores"

Write-Host -ForegroundColor Green "`n========================================= Executando as alteracoes ========================================="

Invoke-Command -ComputerName $entradaServidores -Credential $acessoServidores -ScriptBlock {
    # Valores e keys
    $smb1Key = "SMB1"
    $enableOff = "0"

    $mrxsmb10Key = "Start"
    $mrxsmb10Value = "4"

    $LanmanWorkstationKey = "DependOnService"
    $LanmanWorkstationValue = @(
        "Bowser",
        "MRxSmb20",
        "NSI"
    )

    #Ajustes
    $smb1 = (Get-Item HKLM:\).OpenSubKey("SYSTEM", $true).CreateSubKey("CurrentControlSet\Services\LanmanServer\Parameters")
    $smb1.SetValue($smb1Key, $enableOff, [Microsoft.Win32.RegistryValueKind]::DWord)

    $mrxsmb10 = (Get-Item HKLM:\).OpenSubKey("SYSTEM", $true).CreateSubKey("CurrentControlSet\Services\mrxsmb10")
    $mrxsmb10.SetValue($mrxsmb10Key, $mrxsmb10Value, [Microsoft.Win32.RegistryValueKind]::DWord)

    New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanWorkstation" -PropertyType MultiString `
     -Name $LanmanWorkstationKey -Value $LanmanWorkstationValue -Force
}

Write-Host -ForegroundColor Green "`nRealizado os ajustes com sucesso"

Pause