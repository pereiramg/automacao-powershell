<#
    Objetivo: Remover usuário em grupos especificos de cada servidor
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>

Write-Host -ForegroundColor Green "========================================= Remover usuario em grupos especificos de cada servidor ========================================="

#Importando o modulo para validação
Import-Module "$PSScriptRoot\..\winrm\TesteWinRM.ps1" -Force

# Solicitando o arquivo com os servidores
$entradaServidores = Get-Content (Read-Host "Insira o caminho e o nome do txt com os servidores: Ex: c:\temp\servidores.txt ")

#Credenciais de acesso aos servidores
$acessoServidores = Get-Credential -Message "Insira as credencias de acesso aos servidores"
$user = $acessoServidores.UserName.ToUpper().Split("\")[-1]

#Execução do teste de conectividade com o POwershell
Write-Host -ForegroundColor Green "`n========================================= Validacao da porta WinRM ========================================="
testWinRM $entradaServidores $user

$data = Get-Date -Format "ddmmyyyy"
if (Test-Path "$PSScriptRoot\..\logs\$($user)ServerAccept-$($data).txt") {
    $servidoresOK = Get-Content "$PSScriptRoot\..\logs\$($user)ServerAccept-$($data).txt"
    Write-Host -ForegroundColor Green "`nOs servidores que fecharam com sucesso:"
    $servidoresOK
}
else {
    Write-Host -ForegroundColor Red "`nNenhum servidor fechou com sucesso a conectividade com o WinRM"
    Pause
    Break
}

#Capturando o group
Write-Host -ForegroundColor Green "`n========================================= Informacao do Grupo ========================================="
Write-Host "O arquivo precisa conter o nome dos grupos"
$nomeGroup = Get-Content (Read-Host "Informe o caminho e o txt com o nome dos grupos. EX.: c:\temp\grupos.txt")

#Captura dos usuarios
Write-Host -ForegroundColor Green "`n========================================= Informacao dos Usuarios ========================================="
Write-Host "O arquivo precisa conter o dominio e usuario como segue DOMINIO\USUARIO"
$nomeUsuarios = Get-Content (Read-Host "Informe o caminho e o txt com o nome dos usuarios. EX.: c:\temp\usuarios.txt")

Write-Host -ForegroundColor Green "`n========================================= Executando as alteracoes ========================================="
Invoke-Command -ComputerName $servidoresOK -Credential $acessoServidores -ScriptBlock {
    foreach ($groups in $using:nomeGroup) {
        foreach ($users in $using:nomeUsuarios) {
            try {
                $users = $users.Trim()
                Remove-LocalGroupMember -Group $groups -Member $users -ErrorAction Ignore
                Write-Host -ForegroundColor Yellow "O $users foi removido com sucesso no grupo $groups"
            }
            catch [Microsoft.PowerShell.Commands.MemberExixtsException] {
                Write-Warning "O $users não existia no grupo $groups"
            } # fim Catch
        } # fim do foreach
    } # fim do foreach
} # fim do invoke command
Pause