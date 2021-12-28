<#
    Objetivo: Add Existing Hard Disk
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>


Write-Host "`n`n =================================== Add Existing Hard Disk =================================== "

Connet-VIServer [Seu VI Server]

$vm1 = Get-VM -Name [seu server]
$vm2 = Get-VM -Name [seu server]

# Aqui podemos ver o caminho correto dos discos RDM de origem
$hds = Get-HardDisk -VM $vm1
$hds.Filename

#Agora podemos adicionar esses discos para o segundo servidor
New-HardDisk -VM $vm2 -Controller "SCSI Controller 1" -DiskPath "Local onde está o disco"
