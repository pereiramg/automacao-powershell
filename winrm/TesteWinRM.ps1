<#
    Objetivo: Realizar os testes de conectividade do powershell
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>

#Definição da função
function testWinRM($allComputer, $user) {
    $data = Get-Date -Format "ddmmyyyy"
    $serverAccept = "$PSScriptRoot\..\logs\$($user)ServerAccept-$($data).txt"
    $serverError = "$PSScriptRoot\..\logs\$($user)ServerError-$($data).txt"

    if (Test-Path $serverAccept){Remove-Item $serverAccept}
    elseif (Test-Path $serverError) {Remove-Item $serverError}

    #Realiza o teste de conectividade para os servidores
    ForEach ($server in $allComputer){
        if (Test-WSMan -ComputerName $server -ErrorAction SilentlyContinue){
            # Atribuindo dados aos logs dos servidores OK
            $server | Out-File -Append "$PSScriptRoot\..\logs\$($user)ServerAccept-$($data).txt"
        }else{
            # Atribuindo dados aos logs dos servidores OK
            $server | Out-File -Append "$PSScriptRoot\..\logs\$($user)ServerError-$($data).txt"
        } # fim do else
    } # fim do foreach
    
    Write-Host "`n`nFavor validar o arquivo $PSScriptRoot\..\logs\$($user)ServerError-$($data).txt para saber os servidores com falhas de conexao"
    Write-Host "`n`nOs servidores nesse arquivo nao serao carregados`n"
}




