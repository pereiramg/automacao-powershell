<#
    Objetivo: Menu principal
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>

Write-Host -ForegroundColor Green - "`n`n==================================== Menu Automacao ===================================="

while ($menu -ne 37) {

    $menuOpcao = {
        Write-Host -ForegroundColor Green "`n`n                          Escolha a opcao na qual deseja executar`n`n"
        Write-Host -ForegroundColor Green "---------------------------------------- SCCM ----------------------------------------`n"
        # Write-Host "`b 1 - Verificar os updates pendentes nos servidores"
        # Write-Host "`b 2 - Verificar o status dos updates nos servidores"
        # Write-Host "`b 3 - Realizar a instalação dos Updates pendentes no servidor"
        # Write-Host "`b 4 - SCCM - Adicionar maquinas na Collection especificada do Ambiente de Producao"
        # Write-Host "`b 5 - SCCM - Adicionar maquinas na Collection especificada do ambiente de Homol e DEV"
        # Write-Host "`b 6 - Remover maquinas da Collection especificada do ambiente de Producao"
        # Write-Host "`b 7 - Remover maquinas da Collection especificada do ambiente de Homol e DEV"
        # Write-Host "`b 8 - Dual Scan Disable - Windows Update and SCCM"
        Write-Host -ForegroundColor Green "`n---------------------------------------- Usuarios ----------------------------------------`n"
        Write-Host "`b 9 - Inserir usarios/grupos em grupos especificos de cada servidor" #OK
        Write-Host "`b 10 - Remover usuarios/grupos em grupos especificos de cada servidor" #OK
        Write-Host -ForegroundColor Green "`n---------------------------------------- Seguranca ----------------------------------------`n"
        # Write-Host "`b 12 - Habilitar o Firewall - Profile Domain / Private / Public"
        # Write-Host "`b 13 - Desativar o SMBv1"
        # Write-Host "`b 14 - Habilitar o SMBv2 RequireSecuritySignature ON"
        # Write-Host "`b 15 - Remover Shares especificados"
        # Write-Host "`b 16 - Habilitar o TLS 1.0"
        # Write-Host "`b 17 - Desabilitar o TLS 1.0"
        # Write-Host "`b 18 - Habilitar o TLS 1.2, Ciphers e demais protocolos"
        # Write-Host "`b 19 - Rollback do TLS 1.2, Ciphers e demais protocolos"
        Write-Host -ForegroundColor Green "`n---------------------------------------- Utilitarios ----------------------------------------`n"
        Write-Host "`b 20 - Instalação do Simple TCP/IP Services no Windows Server" #OK
        Write-Host "`b 21 - Execução de scripts remoto" #OK
        Write-Host "`b 25 - Ping sob demanda" #OK

        Write-Host "`b 29 - Copia de Arquivos e pastas" #OK
        Write-Host "`b 30 - Deletar Arquivos e pastas" #OK
        #Write-Host "`b 30 - Execução de Scripts Remoto"
        Write-Host -ForegroundColor Green "`n---------------------------------------- Cluster ----------------------------------------`n"
        # Write-Host "`b 31 - Adicionar as interfaces de rede necessarias para servidores cluster"
        # Write-Host "`b 32 - Criacao de servidor Cluster"
        # Write-Host "`b 33 - Formatação de discos Cluster SQL"
        # Write-Host "`b 34 - Adicionar os discos no Cluster e Group"
        # Write-Host "`b 35 - Set Cluster log para 1024"
        Write-Host -ForegroundColor Green "`n---------------------------------------- IIS ----------------------------------------`n"
        Write-Host "`b 35 - Instalação do Windows .net Framework 3.5" #OK
        Write-Host "`b 36 - Disable o Delete e Options no HTTP Verbs IIS" #OK
        Write-Host -ForegroundColor Green "`n---------------------------------------- Sair ----------------------------------------`n"
        Write-Host "`b 37 - Nenhuma acao a ser realizada. O script será fechado" #OK

        $menu = Read-Host "`nSelecione as opções desejadas: [1 ao 37]"

        switch ($menu) {
            1 { & "$PSScriptRoot\"}
            1 { & "$PSScriptRoot\"}
            1 { & "$PSScriptRoot\"}
            9 { & "$PSScriptRoot\usuarios\AddUserLocalGroupMembers.ps1"}
            10 { & "$PSScriptRoot\usuarios\RemoveUserLocalGroupMembers.ps1"}
            20 { & "$PSScriptRoot\utilitarios\InstallSimpleTcpIp.ps1"}
            21 { & "$PSScriptRoot\utilitarios\ExecuteRemotePS1.ps1"}
            25 { & "$PSScriptRoot\utilitarios\PingN.ps1"}
            29 { & "$PSScriptRoot\utilitarios\CopyFolderFile.ps1"}
            30 { & "$PSScriptRoot\utilitarios\RemoveFolderFile.ps1"}
            35 { & "$PSScriptRoot\iis\InstallFramework35.ps1"}
            36 { & "$PSScriptRoot\iis\DisableDeleteOptionsHTTPVerbs.ps1"}
            1 { & "$PSScriptRoot\"}
            1 { & "$PSScriptRoot\"}
            37 { Write-Host -ForegroundColor Green "`nUma pena, o sistema sera fechado`n"}
            Default {"`n`bEntrada nao e valida`n"
                .$menuOpcao} #Fechamento do Default
        } # Fechamento do Switch
    } # Fechamento do $menuOpcao
    .$menuOpcao
} # Fechamento do While

$menu = 0

Pause