<#
    Objetivo: Função para realizar telnet em servidores Linux
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>

<#
$origem = "Servidor"
$destino = "Servidor"
$porta = 445
$senha = Get-Credential -Message "Insira usuario e senha para acesso ao servidor de origem"
#>

function telnet_linux($origem, $destino, $porta, $senha) {

    Import-Module -Name Posh-SSH
    Remove-SSHTrustedHost "$origem"

    $server_linux = New-SSHSession -ComputerName $origem -Credential $senha -AcceptKey:$true
    $resultado_linux = Invoke-SSHCommand $server_linux.SessionId -Command "echo exit | telnet $destino $porta"
    if ($server_linux){ Remove-SSHSession $server_linux.SessionId}
    Return $resultado_linux
}
