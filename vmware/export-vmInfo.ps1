<#
    Objetivo: EXPORT-VMInfo
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>

Write-Host "`n`n=================== EXPORT-VMInfo ==================`n`n" -ForegroundColor Green

# Criação da função
funcion EXPORT-VMInfo {
    $servers = Get-Content(Read-Host "Digite o nome do TXT onde estao as informacoes das VM's")
    
    foreach($server in $servers){
        Get-VM $server | Select-Object Name,PowerState,@{N=}
    }
}