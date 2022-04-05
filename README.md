# Automacao Powershell
O projeto visa criar diversos scritps em PowerShell para realizar instalação de pacotes e correção de problemas no Windows Server 2012/2016/2019
<br/><br/>
* ### activeDirectory
  * __create-groups-ad.ps1__ --> Script para Criação de grupos no AD.
<br/><br/>
* ### cluster-microsoft
  * __add-interface.ps1__ --> Script utilizado para adicionar as interfaces de rede HB e Backup usando o PowerCli, ele associa as VLANs e configura os IPs nas interfaces.
  * __add-interface.csv__ --> Arquivo CSV para dar suporte ao _add-interface.ps1_.
  * __createClsuter.ps1__ --> Script feito para a instalação do cluster como configurar os IPs de HB e Backup.
  * __format-disk-cluster.ps1__ --> Script para formatação dos discos no padrão SQL Server, onde os discos possui tamanho de 64k e depois faz o Mount Point.
  * __format-disk-cluster.txt__ --> Arquivo de suporte onde ele deve ser preenchido e carregado tanto pelo _format-disk-cluster.ps1_ e _add-disk-cluster.ps1_.
  * __add-disk-cluster.ps1__ --> Script para adicionar os discos no cluster e no grupo. 
  * __set-log-cluster.ps1__ --> Script para configurar o tamanho do log do cluster, deixei como 1024.
  
  Obs:   Todos os scripts devem ser executados diretamente na origem, com exceção do __add-interface.ps1__, pois a origem precisar ser o PowerCli e acesso ao Vcenter.
         Caso precise executar remoto, pode usar PSSession, ou modificar e colocar dentro de um Invoke-Command
<br/><br/>
* ### iis
  * __DisableDeleteOptionsHTTPVerbs.ps1__ --> Script para efetuar o Disable o Delete e Options no HTTP Verbs IIS no IIS. Precisa criar um txt com os nomes dos servidores.
  * __installFramework35.ps1__ --> Script para Instalação do Windows .net Framework 3.5, precisa informar um txt com a lista dos servidores.
<br/><br/>
* ### sccm
  * __addComputerCollection.ps1__ --> Script para Adicionar Computer em uma Collection.
  * __dual-scan-disable.ps1__ --> Script para Disabilita o Dual Scan.
  * __ForceUpdateSCCM.ps1__ --> Script para Forçar os updates pendentes no servidor
  * __RemoveComputerCollection.ps1__ --> Script para Remove Computer em uma Collection
  * __StatusUpdates.ps1__ --> Script para Verificar os status dos updates nos servidores.
  * __UpdatesPendentes.ps1__ --> Script para verificar os Updates Pendentes.
<br/><br/>
* ### seguranca
  * __firewall-on.ps1__ --> Script para Ativação do firewall Domain, Private, Public.
  * __removeShares.ps1__ --> Script para Remover Shares indevidas
  * __SMBv1OFF.ps1__ --> Script para Desabilitar o SMBv1 do Windows Server.
  * __SMBv1OFF-Rollback.ps1__ --> Script para realizar o Rollback do SMBv1OFF.ps1
  * __SMBv2-RequireSecuritySignature-ON.ps1__ --> Script para SMBv2 Require Security Signature ON.
  * __TlsSslOn1-0-Rollback.ps1__ --> Script para realizar o Rollback do TlsSslOn1-0.ps1.
  * __TlsSslOn1-0.ps1__ --> Script para Habilitar o TLS 1.0.
  * __TlsSslOn1-2.ps1__ --> Script para Habilitar o TLS 1.2, Ciphers e demais protocolos.
  * __TlsSslOn1-2-Rollback.ps1__ --> Script para realizar o Rollback do TlsSslOn1-2.ps1
<br/><br/>
* ### usuarios
  * __AddUserLocalGroupMembers.ps1__ --> Script para Inserir usuários em grupos especificos de cada servidor. Precisa criar 3 arquivos txt conforme 
  * __RemoveUserLocalGroupMembers.ps1__ --> Script para Remover usuários em grupos especificos de cada servidor.
<br/><br/>
* ### utilitarios
  * __CopyFolderFile.ps1__ --> Script para Copiar Folder ou Files. Executar na origem do arquivo a ser copiado.
  * __execute-remote-scripts-PS.ps1__ --> Script para Execução de scripts Powershell remoto.
  * __install-SimpleTcpIp.ps1__ --> Script para Instalação do Simple TCP/IP Services no Windows Server
  * __ping-NServers.ps1__ --> Script Ping sob demanda. Utilizei os Forms para testar, muito legal.
  * __RemoveFolderFile.ps1__ --> Script para Deletar Folder ou Files
  * __restartServers.ps1__ --> Script para Reiniciar Servidores.
  * __telnet-linux.psm1__ --> Para ser usado como um modulo com a passagem de parametros.
  * __telnet-windows.psm1__ --> Para ser usado como um modulo com a passagem de parametros.
  * __telnet.ps1__ --> Script em modo visual para realizar Telnet (Projeto particular para testes visual)
  * __linux.jpg__ --> Arquivo imagem do telnet.ps1
  * __windows.jpg__ --> Arquivo imagem do telnet.ps1
<br/><br/>
* ### vmware (PowerCli)
  * __add-existing-hard-disk.ps1__ --> Script para adicionar disco existente em um servidor
  * __change-cpu-memory.ps1__ --> Script para Ajustar CPU e Memoria dos servidores
  * __change-cpu-memory.csv__ --> Modelo de informações para o script change-cpu-memory.ps1
  * __create-datastore-vmfs-6.ps1__ --> Script para criação de datastorage VMFS 6
  * __discos-rdm-report.ps1__ --> Script para extrair relatorios de discos RDM
  * __LigarServidores.ps1__ --> Script para ligar servidores
<br/><br/>
* ### winrm
  * __TesteWinRM.ps1__ --> Script para Realizar os testes de conectividade do powershell.

