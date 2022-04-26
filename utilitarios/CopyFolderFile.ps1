<#
    Objetivo: Copiar Folder ou Files
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>

Write-Host -ForegroundColor Green "========================================= Copiar Folder ou Files ========================================="

# Solicitando o arquivo com os servidores
$entradaServidores = Get-Content (Read-Host "Insira o caminho e o nome do txt com os servidores: Ex: c:\temp\servidores.txt ")

#Credenciais de acesso aos servidores
$acessoServidores = Get-Credential -Message "Insira as credencias de acesso aos servidores"

$origemFile = Read-Host "Informe a ogirem para realizar a copia. Ex.: C:\CopyFolder"

$destino = Read-Host "Informe o destino para realizar a copia. Ex.: C:\temp\NewFolder"

Write-Host -ForegroundColor Green "`n========================================= Executando as alteracoes ========================================="

$hoje = Get-Date -Format "dd-MM-yyyy"
Start-Transcript -Path "$PSScriptRoot\log-copy-$($hoje).log" -Append

foreach ($server in $entradaServidores){
    try{
        $session = New-PSSession -ComputerName $server -Credential $acessoServidores -ErrorAction SilentlyContinue
        Copy-Item -Path $origemFile -Destination $destino -ToSession $session -Force -Recurse
    }catch{
        Write-Host "Não foi possivel realizar a conexão como servidor $server" -ForegroundColor Red
    }
    
}
Stop-Transcript
Pause