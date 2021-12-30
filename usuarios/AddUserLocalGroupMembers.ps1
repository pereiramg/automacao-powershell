<#
    Objetivo: Inserir usuário em grupos especificos de cada servidor
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>

Write-Host -ForegroundColor Green "========================================= Inserir usuario em grupos especificos de cada servidor ========================================="

# Solicitando o arquivo com os servidores
$entradaServidores = Get-Content (Read-Host "Insira o caminho e o nome do txt com os servidores: Ex: c:\temp\servidores.txt ")

#Credenciais de acesso aos servidores
$acessoServidores = Get-Credential -Message "Insira as credencias de acesso aos servidores"

<# Capturando o group
Exemplos dos Grupos Local que pode ser colocado no arquivo txt:

Access Control Assistance Operators
Administrators
Backup Operators
Cryptographic Operators
Distributed COM Users
Event Log Readers
Guests
Hyper-V Administrators
IIS_IUSRS
Network Configuration Operators
Performance Log Users
Performance Monitor Users
Power Users
Remote Desktop Users
Remote Management Users
Replicator
System Managed Accounts Group
Users

#>
Write-Host -ForegroundColor Green "`n========================================= Informacao do Grupo ========================================="
Write-Host "O arquivo precisa conter o nome dos grupos"
$nomeGroup = Get-Content (Read-Host "Informe o caminho e o txt com o nome dos grupos. EX.: c:\temp\grupos.txt")

#Captura dos usuarios
Write-Host -ForegroundColor Green "`n========================================= Informacao dos Usuarios ========================================="
Write-Host "O arquivo precisa conter o dominio e usuario como segue DOMINIO\USUARIO"
$nomeUsuarios = Get-Content (Read-Host "Informe o caminho e o txt com o nome dos usuarios. EX.: c:\temp\usuarios.txt")

Write-Host -ForegroundColor Green "`n========================================= Executando as alteracoes ========================================="
Invoke-Command -ComputerName $entradaServidores -Credential $acessoServidores -ScriptBlock {
    foreach ($groups in $using:nomeGroup) {
        foreach ($users in $using:nomeUsuarios) {
            try {
                $users = $users.Trim()
                Add-LocalGroupMember -Group $groups -Member $users -ErrorAction Ignore
                Write-Host -ForegroundColor Yellow "O $users foi adicionado com sucesso no grupo $groups"
            }
            catch [Microsoft.PowerShell.Commands.MemberExixtsException] {
                Write-Warning "O $users ja existe no grupo $groups"
            } # fim Catch
        } # fim do foreach
    } # fim do foreach
} # fim do invoke command

Pause