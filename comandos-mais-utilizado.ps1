
Exit-PSSession
Exit

#Importa modulos
Import-Module ActiveDirectory

# Listar as propriedades de um user
Get-ADUser user

# LIstar os grupos que um usuário faz parte
Get-ADPrincipalGroupMembership user | Select-Object Name

# Listar
Get-ADGroupMember "group" | Select-Object name

# Capturar o UserPrincipalName usando o seu email cadastrado
$users = Get-Content "c:\temp\user.txt"
foreach ($user in $users) {
    Get-ADUser -Filter {UserPrincipalName -like $user} | Select-Object Name -ExpandProperty Name | Out-File `
    "c:\temp\resultado.txt" -Append
}

Get-ADUser -Server "dominio.com.br" -Identity user
Resolve-DnsName "dominio.com.br"

# nslookup - resolução de nomes sob demanda
$ips = Get-Content "c:\temp\ips.txt"
foreach ($ip in $ips) {
    Resolve-DnsName $ip | Select-Object NameHost -ExpandProperty NameHost | Out-File "c:\temp\resolucao.txt" -Append
}

# Converter minusculos para maiusculo
$frase = "Teste TESTE"
$frase.ToUpper()
$frase.ToLower()

# Procurar um objeto computer e depois remover ele
Get-ADComputer server
Remove-ADComputer server

#VMWARE
Connect-VIServer [seu_esxi]
Disconnect-VIServer [seu_esxi]

# Saber em qual VIServer está conectado
$Global:DefaultVIServers

# Ignorar certificado na conexão com o VIServer
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:false


# Diretorio onde estão os modulos carregados no PowerShell
$env:PSModulePath

