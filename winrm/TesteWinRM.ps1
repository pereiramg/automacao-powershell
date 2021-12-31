<#
    Objetivo: Realizar os testes de conectividade do powershell
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>

#Definição da função
function testWinRM($allComputer, $user) {
    $data = Get-Date -Format "ddmmyyyy"
    $serverAccept = "c:\temp\ServerAccept-$($data).txt"
    $serverError = "c:\temp\ServerError-$($data).txt"

    if (Test-Path $serverAccept){Remove-Item $serverAccept}
    elseif (Test-Path $serverError) {Remove-Item $serverError}

    #Realiza o teste de conectividade para os servidores
    ForEach ($server in $allComputer){
        if (Test-WSMan -ComputerName $server -ErrorAction SilentlyContinue){
            # Atribuindo dados aos logs dos servidores OK
            $server | Out-File -Append "c:\temp\ServerAccept-$($data).txt"
        }else{
            # Atribuindo dados aos logs dos servidores OK
            $server | Out-File -Append "c:\temp\ServerError-$($data).txt"
        } # fim do else
    } # fim do foreach
    
    Write-Host -ForegroundColor Yellow "`nFavor validar o arquivo c:\temp\ServerError-$($data).txt para consultar os servidores que apresentaram falha"
}

# Criando a pasta c:\temp
if (!(Test-Path "c:\temp")) {
    New-Item -Path "c:\" -Name "temp" -ItemType "directory"
}

# Solicitando o arquivo com os servidores
$entradaServidores = Get-Content (Read-Host "Insira o caminho e o nome do txt com os servidores: Ex: c:\temp\servidores.txt")

#Credenciais de acesso aos servidores
$acessoServidores = Get-Credential -Message "Insira as credencias de acesso aos servidores"
$user = $acessoServidores.UserName.ToUpper().Split("\")[-1]

#Execução do teste de conectividade com o POwershell
Write-Host -ForegroundColor Green "`n========================================= Validacao da porta WinRM ========================================="
testWinRM $entradaServidores $user

