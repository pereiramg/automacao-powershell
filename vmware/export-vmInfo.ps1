<#
    Objetivo: Export-VMInfo
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>

Write-Host "`n`n=================== Export-VMInfo ==================`n`n" -ForegroundColor Green

# Criação da função
funcion Export-VMInfo {
    $servers = Get-Content(Read-Host "Digite o nome do TXT onde estao as informacoes das VM's")
    
    foreach($server in $servers){
        Get-VM $server | 
        Select-Object Name,PowerState,
        @{N= "Cluster"; E = { $_.vmhost.parent }},
        @{N = "Host"; E = {$_.vmhost }},
        @{N = "VirtualPortGroup"; E = { Get-VM $server | Get-VirtualPortGroup }},
        MemoryGB,
        ProvisionedSpaceGB,
        Folder,
        @{N = "VCenter"; E = { $_.uid.split("@")[1].split(":")[0] }}
    }
}

#
Export-VMinfo | Export-Csv ExportInfo.csv
