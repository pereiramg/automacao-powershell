<#
    Objetivo: Habilitar o TLS 1.2, Ciphers e demais protocolos
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>

Write-Host -ForegroundColor Green "========================================= Habilitar o TLS 1.2, Ciphers e demais protocolos ========================================="

# Solicitando o arquivo com os servidores
$entradaServidores = Get-Content (Read-Host "Insira o caminho e o nome do txt com os servidores: Ex: c:\temp\servidores.txt")

#Credenciais de acesso aos servidores
$acessoServidores = Get-Credential -Message "Insira as credencias de acesso aos servidores"

Write-Host -ForegroundColor Green "`n========================================= Executando as alteracoes ========================================="

Invoke-Command -ComputerName $entradaServidores -Credential $acessoServidores -ScriptBlock {
    # Valores e Keys
    $enabled = "Enabled"
    $enabledOff = "0"
    $enabledOn = 0xffffffff

    $disableByDefault = "DisabledByDefault"
    $disableByDefaultOff = "1"
    $disableByDefaultOn = "0"

    #Criação das keys Protocols
    $mpuh = (Get-Item HKLM:\).OpenSubKey("SYSTEM", $true).CreateSubKey("CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\Multi-Protocols Unified Hello\Server")
    $mpuh.SetValue($enabled,$enabledOff, [Microsoft.Win32.RegistryValueKind]::DWord)
    
    $pct = (Get-Item HKLM:\).OpenSubKey("SYSTEM", $true).CreateSubKey("CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\PCT 1.0\Server")
    $pct.SetValue($enabled,$enabledOff, [Microsoft.Win32.RegistryValueKind]::DWord)
    
    $ssl20 = (Get-Item HKLM:\).OpenSubKey("SYSTEM", $true).CreateSubKey("CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0\Server")
    $ssl20.SetValue($enabled,$enabledOff, [Microsoft.Win32.RegistryValueKind]::DWord)
    
    $ssl30 = (Get-Item HKLM:\).OpenSubKey("SYSTEM", $true).CreateSubKey("CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Server")
    $ssl30.SetValue($enabled,$enabledOff, [Microsoft.Win32.RegistryValueKind]::DWord)
    
    #Disable TLS 1.0
    $tls10 = (Get-Item HKLM:\).OpenSubKey("SYSTEM", $true).CreateSubKey("CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server")
    $tls10.SetValue($enabled,$enabledOff, [Microsoft.Win32.RegistryValueKind]::DWord)
    $tls10.SetValue($disableByDefault, $disableByDefaultOff, [Microsoft.Win32.RegistryValueKind]::DWord)

    $tls10 = (Get-Item HKLM:\).OpenSubKey("SYSTEM", $true).CreateSubKey("CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Client")
    $tls10.SetValue($enabled,$enabledOff, [Microsoft.Win32.RegistryValueKind]::DWord)
    $tls10.SetValue($disableByDefault, $disableByDefaultOff, [Microsoft.Win32.RegistryValueKind]::DWord)

    #Disable TLS 1.1
    $tls11 = (Get-Item HKLM:\).OpenSubKey("SYSTEM", $true).CreateSubKey("CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server")
    $tls11.SetValue($enabled,$enabledOff, [Microsoft.Win32.RegistryValueKind]::DWord)
    $tls11.SetValue($disableByDefault, $disableByDefaultOff, [Microsoft.Win32.RegistryValueKind]::DWord)

    $tls11 = (Get-Item HKLM:\).OpenSubKey("SYSTEM", $true).CreateSubKey("CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Client")
    $tls11.SetValue($enabled,$enabledOff, [Microsoft.Win32.RegistryValueKind]::DWord)
    $tls11.SetValue($disableByDefault, $disableByDefaultOff, [Microsoft.Win32.RegistryValueKind]::DWord)

     #Enable TLS 1.2
     $tls12 = (Get-Item HKLM:\).OpenSubKey("SYSTEM", $true).CreateSubKey("CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server")
     $tls12.SetValue($enabled,$enabledOff, [Microsoft.Win32.RegistryValueKind]::DWord)
     $tls12.SetValue($disableByDefault, $disableByDefaultOff, [Microsoft.Win32.RegistryValueKind]::DWord)
 
     $tls12 = (Get-Item HKLM:\).OpenSubKey("SYSTEM", $true).CreateSubKey("CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client")
     $tls12.SetValue($enabled,$enabledOn, [Microsoft.Win32.RegistryValueKind]::DWord)
     $tls12.SetValue($disableByDefault, $disableByDefaultOn, [Microsoft.Win32.RegistryValueKind]::DWord)

     #Criação das Keys Ciphers
     $aes128 = (Get-Item HKLM:\).OpenSubKey("SYSTEM", $true).CreateSubKey("CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\AES 128/128")
     $aes128.SetValue($enabled,$enabledOn, [Microsoft.Win32.RegistryValueKind]::DWord)

     $aes256 = (Get-Item HKLM:\).OpenSubKey("SYSTEM", $true).CreateSubKey("CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\AES 256/256")
     $aes256.SetValue($enabled,$enabledOn, [Microsoft.Win32.RegistryValueKind]::DWord)
 
     $des168168 = (Get-Item HKLM:\).OpenSubKey("SYSTEM", $true).CreateSubKey("CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\Triple DES 168/168")
     $des168168.SetValue($enabled,$enabledOff, [Microsoft.Win32.RegistryValueKind]::DWord)
 
     $des168 = (Get-Item HKLM:\).OpenSubKey("SYSTEM", $true).CreateSubKey("CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\Triple DES 168")
     $des168.SetValue($enabled,$enabledOff, [Microsoft.Win32.RegistryValueKind]::DWord)

     $des5656 = (Get-Item HKLM:\).OpenSubKey("SYSTEM", $true).CreateSubKey("CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\DES 56/56")
     $des5656.SetValue($enabled,$enabledOff, [Microsoft.Win32.RegistryValueKind]::DWord)
 
     $nullChiper = (Get-Item HKLM:\).OpenSubKey("SYSTEM", $true).CreateSubKey("CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\NULL")
     $nullChiper.SetValue($enabled,$enabledOff, [Microsoft.Win32.RegistryValueKind]::DWord)
 
     $rc2128 = (Get-Item HKLM:\).OpenSubKey("SYSTEM", $true).CreateSubKey("CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 128/128")
     $rc2128.SetValue($enabled,$enabledOff, [Microsoft.Win32.RegistryValueKind]::DWord)
 
     $rc240 = (Get-Item HKLM:\).OpenSubKey("SYSTEM", $true).CreateSubKey("CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 40/128")
     $rc240.SetValue($enabled,$enabledOff, [Microsoft.Win32.RegistryValueKind]::DWord)
 
     $rc256 = (Get-Item HKLM:\).OpenSubKey("SYSTEM", $true).CreateSubKey("CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 56/128")
     $rc256.SetValue($enabled,$enabledOff, [Microsoft.Win32.RegistryValueKind]::DWord)
 
     $rc4128 = (Get-Item HKLM:\).OpenSubKey("SYSTEM", $true).CreateSubKey("CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 128/128")
     $rc4128.SetValue($enabled,$enabledOff, [Microsoft.Win32.RegistryValueKind]::DWord)

     $rc440 = (Get-Item HKLM:\).OpenSubKey("SYSTEM", $true).CreateSubKey("CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 40/128")
     $rc440.SetValue($enabled,$enabledOff, [Microsoft.Win32.RegistryValueKind]::DWord)
 
     $rc456 = (Get-Item HKLM:\).OpenSubKey("SYSTEM", $true).CreateSubKey("CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 56/128")
     $rc456.SetValue($enabled,$enabledOff, [Microsoft.Win32.RegistryValueKind]::DWord)

     $rc464 = (Get-Item HKLM:\).OpenSubKey("SYSTEM", $true).CreateSubKey("CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 64/128")
     $rc464.SetValue($enabled,$enabledOff, [Microsoft.Win32.RegistryValueKind]::DWord)

     #Criação das Keys Hashes
     $md5 = (Get-Item HKLM:\).OpenSubKey("SYSTEM", $true).CreateSubKey("CurrentControlSet\Control\SecurityProviders\SCHANNEL\Hashes\MD5")
     $md5.SetValue($enabled,$enabledOff, [Microsoft.Win32.RegistryValueKind]::DWord)

     $sha = (Get-Item HKLM:\).OpenSubKey("SYSTEM", $true).CreateSubKey("CurrentControlSet\Control\SecurityProviders\SCHANNEL\Hashes\SHA")
     $sha.SetValue($enabled,$enabledOn, [Microsoft.Win32.RegistryValueKind]::DWord)

     $sha256 = (Get-Item HKLM:\).OpenSubKey("SYSTEM", $true).CreateSubKey("CurrentControlSet\Control\SecurityProviders\SCHANNEL\Hashes\SHA256")
     $sha256.SetValue($enabled,$enabledOn, [Microsoft.Win32.RegistryValueKind]::DWord)

     $sha384 = (Get-Item HKLM:\).OpenSubKey("SYSTEM", $true).CreateSubKey("CurrentControlSet\Control\SecurityProviders\SCHANNEL\Hashes\SHA384")
     $sha384.SetValue($enabled,$enabledOn, [Microsoft.Win32.RegistryValueKind]::DWord)

     $sha512 = (Get-Item HKLM:\).OpenSubKey("SYSTEM", $true).CreateSubKey("CurrentControlSet\Control\SecurityProviders\SCHANNEL\Hashes\SHA512")
     $sha512.SetValue($enabled,$enabledOn, [Microsoft.Win32.RegistryValueKind]::DWord)

     Write-Host -ForegroundColor Green "Executado com sucesso no $servidoresOK"
}

Pause