<#
    Objetivo: Menu principal
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>

Write-Host -ForegroundColor Green - "`n`n==================================== Menu Automacao ===================================="

while ($menu -ne 36) {

    $menuOpcao = {
        Write-Host -ForegroundColor Green "`n`n                          Escolha a opcao na qual deseja executar`n`n"
        Write-Host -ForegroundColor Green "---------------------------------------- SCCM ----------------------------------------`n"
        Write-Host "`b 1 - Verificar os updates pendentes nos servidores"
        Write-Host "`b 2 - Verificar o status dos updates nos servidores"
        Write-Host "`b 3 - Realizar a instalação dos Updates pendentes no servidor"
        Write-Host "`b 4 - SCCM - Adicionar maquinas na Collection especificada do Ambiente de Producao"
        Write-Host "`b 5 - SCCM - Adicionar maquinas na Collection especificada do ambiente de Homol e DEV"
        Write-Host "`b 6 - Remover maquinas da Collection especificada do ambiente de Producao"
        Write-Host "`b 7 - Remover maquinas da Collection especificada do ambiente de Homol e DEV"
        Write-Host "`b 8 - Dual Scan Disable - Windows Update and SCCM"
        Write-Host -ForegroundColor Green "`n---------------------------------------- Usuarios ----------------------------------------`n"
        Write-Host "`b 9 - Inserir usarios em grupos especificos de cada servidor"
        Write-Host "`b 10 - Remover usuarios em grupos especificos de cada servidor"
        Write-Host "`b 11 - Adicionar os grupos LOCALADMIN_DEF" #Analisar essa opção
        Write-Host -ForegroundColor Green "`n---------------------------------------- Seguranca ----------------------------------------`n"
        Write-Host "`b 12 - Habilitar o Firewall - Profile Domain / Private / Public"
        Write-Host "`b 13 - Desativar o SMBv1"
        Write-Host "`b 14 - Habilitar o SMBv2 RequireSecuritySignature ON"
        Write-Host "`b 15 - Remover Shares especificados"
        Write-Host "`b 16 - Habilitar o TLS 1.0"
        Write-Host "`b 17 - Desabilitar o TLS 1.0"
        Write-Host "`b 18 - Habilitar o TLS 1.2, Ciphers e demais protocolos"
        Write-Host "`b 19 - Rollback do TLS 1.2, Ciphers e demais protocolos"
        Write-Host -ForegroundColor Green "`n---------------------------------------- Utilitarios ----------------------------------------`n"
        Write-Host "`b 20 - Realizar boot dos servidores"
        Write-Host "`b 21 - Desativar o registro de DNS das interfaces de rede"
        Write-Host "`b 22 - Inserir servidores de DNS em uma interface especifica"
        Write-Host "`b 23 - Converter Windows Evaluation para Server Standard 2016"
        Write-Host "`b 24 - Realizar TELNET sob demanda em servidores WINDOWS"
        Write-Host "`b 25 - Adicionar interfaces de rede" #Analisar
        Write-Host "`b 26 - Remover o windows-Feature SNMP services"
        Write-Host "`b 27 - Captura do MAC Address"
        Write-Host "`b 28 - Remocao de Package"
        Write-Host "`b 29 - Realiza a copia de pastas"
        Write-Host "`b 30 - Execução de Scripts Remoto"
        Write-Host -ForegroundColor Green "`n---------------------------------------- Cluster ----------------------------------------`n"
        Write-Host "`b 31 - Adicionar as interfaces de rede necessarias para servidores cluster"
        Write-Host "`b 32 - Criacao de servidor Cluster"
        Write-Host "`b 33 - Formatação de discos Cluster SQL"
        Write-Host "`b 34 - Adicionar os discos no Cluster e Group"
        Write-Host "`b 35 - Set Cluster log para 1024"
        Write-Host -ForegroundColor Green "`n---------------------------------------- IIS ----------------------------------------`n"
        Write-Host "`b 36 - Disable o Delete e Options no HTTP Verbs IIS"

        Write-Host -ForegroundColor Green "`n---------------------------------------- Sair ----------------------------------------`n"
        Write-Host "`b 37 - Nenhuma acao a ser realizada. O script será fechado"

        $menu = Read-Host "`nSelecione as opções desejadas: [1 ao 36]"

        switch ($menu) {
            1 { & "$PSScriptRoot\"}
            1 { & "$PSScriptRoot\"}
            1 { & "$PSScriptRoot\"}
            1 { & "$PSScriptRoot\"}
            1 { & "$PSScriptRoot\"}
            1 { & "$PSScriptRoot\"}
            1 { & "$PSScriptRoot\"}
            36 { & "$PSScriptRoot\iis\DisableDeleteOptionsHTTPVerbs.ps1"}
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