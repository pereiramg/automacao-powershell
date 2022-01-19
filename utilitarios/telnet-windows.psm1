<#
    Objetivo: Função para realizar telnet em servidores windows
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>

<#
$origem = "Servidor"
$destino = "Servidor"
$porta = 445
$senha = Get-Credential -Message "Insira usuario e senha para acesso ao servidor de origem"
#>

function telnet ($origem, $destino, $porta, $senha) {
    Invoke-Command -ComputerName $origem -Credential $senha -ScriptBlock{
        #Validação do IP e DNS
        try{
            $ip = [System.Net.Dns]::GetHostAddresses($Using:destino) |
            Select-Object IPAddressToString -ExpandProperty IPAddressToString
            if ($ip.GetType().Name -eq "Object[]") {
                $ip = $ip[0]
            }
        }catch{
            $erro_ip = "Possivelmete o $Using:destino está errado"
            Return
        }

        $tcpClient = New-Object Net.Sockets.TcpClient
        try{
            $tcpClient.Connect($ip,$Using:porta)
        }catch {}

        if($tcpClient.Connected){
            $tcpClient.Close()
            $msg = "A porta $Using:porta foi conectado com sucesso"
        }
        else{
            msg = "A porta $Using:porta no $ip nao conectou"
        }
        Return $msg
    }
}

