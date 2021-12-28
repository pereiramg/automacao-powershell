Connect-VIServer [seu_esxi]
Disconnect-VIServer [seu_esxi]

$Global:DefaultVIServers

Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:false

#Função EXPORT-VMInfo
funcion EXPORT-VMInfo {
    $VMs = Read-Host "Digite o nome do TXT onde estao as informacoes das VM's"
    
}