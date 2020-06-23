<#
    Objetivo: Adicionar Computer em uma Collection
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>

Write-Host -ForegroundColor Green "========================================= Adicionar Computer em uma Collection ========================================="

#Servidor SCCM
$servidorSCCM = Read-Host "Informe o nome do servidor de SCCM"

$nomeCollection = Read-Host "Informe o nome da Collection para ser adicionada no SCCM"

# Solicitando o arquivo com os servidores
$entradaServidores = Get-Content (Read-Host "Insira o caminho e o nome do txt com os servidores para adicionar na Collection: Ex: c:\temp\servidores.txt")


Write-Host -ForegroundColor Green "`n========================================= Executando as alteracoes ========================================="
try {
    Invoke-Command -ComputerName $servidorSCCM -ScriptBlock {
        #Modulo do SCCM
        $moduleSCCM = "E:\Program Files\Microsoft Configuration Manager\AdminConsole\bin\ConfigurationManager.psd1"
        try {
            Write-Host "Carregando o Modulo do SCCM"
            Import-Module $moduleSCCM -ErrorAction SilentlyContinue -Force
        }catch{
            Write-Host "Nao foi possivel carregar o modulo, favor validar o caminho correto"
            Pause
            Break
        } # fim do catch
        # Descoberta do Site Code
        $siteColletion = (Get-PSDrive -PSProvider CMSite | Sort-Object -Property Name | Select-Object -First 1).Name
        Set-Location "$($siteColletion):"

        #Adicionar os servidores para a collection especificada
        try{
            foreach ($server in $using:entradaServidores) {
                Add-CMDeviceCollectionDirectMembershipRule -CollectionName $using:nomeCollection `
                -ResourceID ((Get-CMDevice -Name $server).ResourceID) -Force -ErrorAction Stop
            }
        }catch{ Write-Host -ForegroundColor Yellow "Servidor $server já estava na Collection"}
    } # fim do Invoke
}catch{ Write-Host "Nao foi possivel conectar no servidor de SCCM $servidorSCCM"}

Write-Host -ForegroundColor Green "Os servidores foram adicionados na Collection $nomeCollection com sucesso"

Pause