<#
    Objetivo: Menu principal para execução no VCENTER
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>

Write-Host -ForegroundColor Green - "`n`n==================================== Menu Automacao VMware ===================================="

while ($menu -ne x) {

    $menuOpcao = {
        Write-Host -ForegroundColor Green "`n`n                          Escolha a opcao na qual deseja executar`n`n"
        Write-Host -ForegroundColor Green "---------------------------------------- VMWARE ----------------------------------------`n"
        Write-Host "`b 1 - Verificar os updates pendentes nos servidores"
        Write-Host "`b 2 - Verificar o status dos updates nos servidores"
        Write-Host "`b 3 - Realizar a instalação dos Updates pendentes no servidor"
        Write-Host "`b 4 - SCCM - Adicionar maquinas na Collection especificada do Ambiente de Producao"
        Write-Host "`b 5 - SCCM - Adicionar maquinas na Collection especificada do ambiente de Homol e DEV"
        Write-Host "`b 6 - Remover maquinas da Collection especificada do ambiente de Producao"
        Write-Host "`b 7 - Remover maquinas da Collection especificada do ambiente de Homol e DEV"
        Write-Host "`b 8 - Dual Scan Disable - Windows Update and SCCM"
        Write-Host -ForegroundColor Green "`n---------------------------------------- Usuarios ----------------------------------------`n"

        Write-Host -ForegroundColor Green "`n---------------------------------------- Sair ----------------------------------------`n"
        Write-Host "`b 36 - Nenhuma acao a ser realizada. O script será fechado"

        $menu = Read-Host "`nSelecione as opções desejadas: [1 ao 36]"

        switch ($menu) {
            1 { & "$PSScriptRoot\"}
            1 { & "$PSScriptRoot\"}
            1 { & "$PSScriptRoot\"}
            1 { & "$PSScriptRoot\"}
            1 { & "$PSScriptRoot\"}
            1 { & "$PSScriptRoot\"}
            1 { & "$PSScriptRoot\"}
            1 { & "$PSScriptRoot\"}
            1 { & "$PSScriptRoot\"}
            1 { & "$PSScriptRoot\"}
            36 { Write-Host -ForegroundColor Green "`nUma pena, o sistema sera fechado`n"}
            Default {"`n`bEntrada nao e valida`n"
                .$menuOpcao} #Fechamento do Default
        } # Fechamento do Switch
    } # Fechamento do $menuOpcao
    .$menuOpcao
} # Fechamento do While

$menu = 0

Pause
Break