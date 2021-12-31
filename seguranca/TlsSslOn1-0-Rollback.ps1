<#
    Objetivo: Rollback do Habilitar o TLS 1.0
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>

Write-Host -ForegroundColor Green "`n`n========================================= TLS 1.0 OFF =========================================`n`n"

# Solicitando o arquivo com os servidores
$entradaServidores = Get-Content (Read-Host "Insira o caminho e o nome do txt com os servidores: Ex: c:\temp\servidores.txt")

#Credenciais de acesso aos servidores
$acessoServidores = Get-Credential -Message "Insira as credencias de acesso aos servidores"

Write-Host -ForegroundColor Green "`n========================================= Executando as alteracoes ========================================="

Invoke-Command -ComputerName $entradaServidores -Credential $acessoServidores -ScriptBlock {
    # Valores e Keys
    $enabled = "Enabled"
    $enabledOff = "0"
    
    $disableByDefault = "DisabledByDefault"
    $disableByDefaultOff = "1"

    #ON TLS 1.0
    $tls10 = (Get-Item HKLM:\).OpenSubKey("SYSTEM", $true).CreateSubKey("CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server")
    $tls10.SetValue($enabled,$enabledOff, [Microsoft.Win32.RegistryValueKind]::DWord)
    $tls10.SetValue($disableByDefault, $disableByDefaultOff, [Microsoft.Win32.RegistryValueKind]::DWord)
     
    $tls10 = (Get-Item HKLM:\).OpenSubKey("SYSTEM", $true).CreateSubKey("CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Client")
    $tls10.SetValue($enabled,$enabledOff, [Microsoft.Win32.RegistryValueKind]::DWord)
    $tls10.SetValue($disableByDefault, $disableByDefaultOff, [Microsoft.Win32.RegistryValueKind]::DWord)

}

Write-Host "Executado nos servidores com sucesso "

Pause