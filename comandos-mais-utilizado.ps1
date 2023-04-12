
Exit-PSSession
Exit

#Importa modulos
Import-Module ActiveDirectory

# Listar as propriedades de um user
Get-ADUser user

#User Local
Get-LocalUser -Name "User1"
$Password = Read-Host -Prompt "Entre com a senha" -AsSecureString
$UserAccount = Get-LocalUser -Name "User1"
$UserAccount | Set-LocalUser -Password $Password


# LIstar os grupos que um usuário faz parte
Get-ADPrincipalGroupMembership user | Select-Object Name

# Listar todos os grupos de um usuário
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


# Diretorio onde estão os modulos carregados no PowerShell
$env:PSModulePath

# Config Time Zone
Get-TimeZone -ListAvailable
Set-TimeZone -Id #<time zone id>

#Renomear um servidor
Rename-Computer -NewName #<new name>

#Adicionar ao dominio
Add-Computer -DomainName "Meu dominio" -Restart

#Listar as NIC
Get-NetAdapter
New-NetIPAddress -InterfaceIndex 7 -IPAddress "meu ip" -PrefixLength 24 -DefaultGateway "gateway"
Set-DnsClientServerAddress -InterfaceIndex 7 -ServerAddresses dn1, dns2

#Updates
#Stop the windows update server service
net stop wuauserv
#set automatic updates
cscript scregedit.wsf /AU 4
#Disable automatic updates
cscript scregedit.wsf /AU 1
#Start tuhe windows update server service
net start wuauserv
#Downloading and installing updates
wuauclt /detectnow

#find roles and features
Get-WindowsFeature *file*
#Install roles and features
Install-WindowsFeature FS-FileServer
Install-WindowsFeature -Name Web-Server -IncludeManagementTools

#enabling remote administration
Configure-SMRemoting -Enable
#Enable remote command powershell
Enable-PSRemoting -Force
#Config winrm
winrm quickconfig

#Firewall
Get-NetFirewallRule *remote* | Format-Table
#enable
Set-NetFirewallRule -Name "RemoteFwAdmin-In-TCP" -Enabled True
Set-NetFirewallRule -Name "RemoteFwAdmin-RPCSS-In-TCP" -Enabled True



#VMWARE
Connect-VIServer [seu_esxi]
Disconnect-VIServer [seu_esxi]

# Saber em qual VIServer está conectado
$Global:DefaultVIServers

# Ignorar certificado na conexão com o VIServer
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:false
