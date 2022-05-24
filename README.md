# Automacao Powershell
O projeto visa criar diversos scritps em PowerShell para realizar instalação de pacotes, consultas, alterações e correção de problemas no Windows Server 2012/2016/2019
<br/><br/>
* ### ACTIVE DIRECTORY
  * __create-groups-ad.ps1__ --> Script para Criação de grupos no AD.
<br/><br/>
* ### CLUSTER MICROSOFT
  * __add-interface.ps1__ --> Script utilizado para adicionar as interfaces de rede HB e Backup usando o PowerCli, ele associa as VLANs e configura os IPs nas interfaces.
  * __add-interface.csv__ --> Arquivo CSV para dar suporte ao _add-interface.ps1_.
  * __createClsuter.ps1__ --> Script feito para a instalação do cluster como configurar os IPs de HB e Backup.
  * __format-disk-cluster.ps1__ --> Script para formatação dos discos no padrão SQL Server, onde os discos possui tamanho de 64k e depois faz o Mount Point.
  * __format-disk-cluster.txt__ --> Arquivo de suporte onde ele deve ser preenchido e carregado tanto pelo _format-disk-cluster.ps1_ e _add-disk-cluster.ps1_.
  * __add-disk-cluster.ps1__ --> Script para adicionar os discos no cluster e no grupo. 
  * __set-log-cluster.ps1__ --> Script para configurar o tamanho do log do cluster, deixei como 1024.
  
  Obs:   Todos os scripts devem ser executados diretamente na origem, com exceção do __add-interface.ps1__, pois a origem precisar ter o modulo do PowerCli e acesso ao Vcenter.
         Caso precise executar remoto, pode usar PSSession, ou modificar e colocar dentro de um Invoke-Command
<br/><br/>
* ### IIS
  * __DisableDeleteOptionsHTTPVerbs.ps1__ --> Script para efetuar o Disable "Delete e Options no HTTP Verbs IIS" no IIS. Precisa criar um txt com os nomes dos servidores.
  * __installFramework35.ps1__ --> Script para Instalação do Windows .net Framework 3.5. Precisa informar um txt com a lista dos servidores.
<br/><br/>
* ### SCCM
  * __addComputerCollection.ps1__ --> Script para Adicionar o Computer em uma Collection.
  * __dual-scan-disable.ps1__ --> Script para Disabilita o Dual Scan.
  * __ForceUpdateSCCM.ps1__ --> Script para Forçar os updates pendentes no servidor
  * __RemoveComputerCollection.ps1__ --> Script para Remove o Computer de uma Collection
  * __StatusUpdates.ps1__ --> Script para Verificar os status dos updates nos servidores.
  * __UpdatesPendentes.ps1__ --> Script para verificar os Updates Pendentes.
<br/><br/>
* ### SEGURANÇA
  * __firewall-on.ps1__ --> Script para Ativação do firewall Domain, Private, Public.
  * __removeShares.ps1__ --> Script para Remover Shares indevidas
  * __SMBv1OFF.ps1__ --> Script para Desabilitar o SMBv1 do Windows Server.
  * __SMBv1OFF-Rollback.ps1__ --> Script para realizar o Rollback do SMBv1OFF.ps1
  * __SMBv2-RequireSecuritySignature-ON.ps1__ --> Script para aplicar o SMBv2 Require Security Signature ON.
  * __TlsSslOn1-0-Rollback.ps1__ --> Script para realizar o Rollback do TlsSslOn1-0.ps1.
  * __TlsSslOn1-0.ps1__ --> Script para Habilitar o TLS 1.0.
  * __TlsSslOn1-2.ps1__ --> Script para Habilitar o TLS 1.2, Ciphers e demais protocolos.
  * __TlsSslOn1-2-Rollback.ps1__ --> Script para realizar o Rollback do TlsSslOn1-2.ps1
<br/><br/>
* ### USUARIOS
  * __AddUserLocalGroupMembers.ps1__ --> Script para Inserir usuários em grupos especificos de cada servidor. Precisa criar 3 arquivos txt conforme será descrito na execução
  * __RemoveUserLocalGroupMembers.ps1__ --> Script para Remover usuários em grupos especificos de cada servidor.
<br/><br/>
* ### UTILITÁRIOS
  * __capture-MAC.ps1__ --> Script para Captura do MAC Address em servidores Windows.
  * __CopyFolderFile.ps1__ --> Script para Copiar Folder ou Files. Executar na origem do arquivo a ser copiado.
  * __dotnet-Hosting-2-1-18-win.ps1__ --> Script para instalação do dotnet-Hosting-2-1-18-win. Prestar a atenção no nome e local do EXE
  * __execute-remote-scripts-PS.ps1__ --> Script para Execução de outros scripts Powershell remoto.
  * __format-disk-L.ps1__ --> Script para Formatar o disco L:\. Aqui ele vai buscar o disco sem partição com tamanho de 10gb. Tudo pode ser customizado.
  * __install-SimpleTcpIp.ps1__ --> Script para Instalação do Simple TCP/IP Services no Windows Server
  * __ping-NServers.ps1__ --> Script para realizar Ping sob demanda. Utilizei os Forms para testar, muito legal.
  * __RemoveFolderFile.ps1__ --> Script para Deletar Folder ou Files
  * __restartServers.ps1__ --> Script para Reiniciar Servidores.
  * __rewrite_amd64_en-US.ps1__ --> Script para instalação do rewrite_amd64_en-US.msi. Prestar a atenção no nome e local do MSI
  * __telnet-linux.psm1__ --> Para ser usado como um modulo com a passagem de parametros.
  * __telnet-windows.psm1__ --> Para ser usado como um modulo com a passagem de parametros.
  * __telnet.ps1__ --> Script em modo visual para realizar Telnet (Projeto particular para testes visual)
  * __linux.jpg__ --> Arquivo imagem do telnet.ps1
  * __windows.jpg__ --> Arquivo imagem do telnet.ps1
<br/><br/>
* ### VMWARE (PowerCli)
  * __add-existing-hard-disk.ps1__ --> Script para adicionar disco existente em um servidor.
  * __add-new-ethernet-vm.ps1__ --> Script para adicionar uma nova interface de rede em servidores Windows.
  * __add-new-ethernet-vm.csv__ --> Modelo de informações para o script add-new-ethernet-vm.ps1.
  * __change-cpu-memory.ps1__ --> Script para Ajustar CPU e Memoria dos servidores.
  * __change-cpu-memory.csv__ --> Modelo de informações para o script change-cpu-memory.ps1.
  * __config-network-linux.ps1__ --> Script para Configurações de IPs-Linux.
  * __configMACAddress.ps1__ --> Script para Configurar o MAC Address em servidores
  * __configMACAddress.csv__ --> Modelo de informações para o script configMACAddress.ps1
  * __config-ip-linux.sh__ --> Script de suporte ao config-network-linux.ps1.
  * __create-datastore-vmfs-6.ps1__ --> Script para criação de datastorage VMFS 6.
  * __create-datastore-vmfs-6.csv__ --> Modelo de informações para o script create-datastore-vmfs-6.ps1.
  * __deployVMWare.ps1__ --> Script para Criação de servidores no VCenter.
  * __deployVMWare.csv__ --> Modelo de informações para o script deployVMWare.ps1
  * __discos-rdm-report.ps1__ --> Script para extrair relatorios de discos RDM.
  * __enable-network.ps1__ --> Script para Ativar uma interface de Rede disable no VMware
  * __export-vmInfo.ps1__ --> Script para Export-VMInfo.
  * __get-HBAs.ps1__ --> Script para Captura dos WWN e LUN ID
  * __get-nics.ps1__ --> Script para Obter switch e porta de cada ESXi de um cluster
  * __LigarServidores.ps1__ --> Script para ligar servidores.
  * __move-vm-folder.ps1__ --> Script para Mover servidores para um folder.
  * __move-vm-folder.csv__ --> Modelo de informações para o script move-vm-folder.ps1.
  * __moveVM-VCenterCross.ps1__ --> Script para mover servidores entre host esxi e VCenters
  * __moveVM-VCenterCross.csv__ --> Modelo de informações para o script moveVM-VCenterCross.ps1
  * __recapacity-disk.ps1__ --> Script para Recapacity Disk.
  * __recapacity-disk.csv__ --> Modelo de informações para o script recapacity-disk.ps1.
  * __transfer-file-datastore.ps1__ --> Script para Transferencia de arquivos para um datastore
<br/><br/>
* ### WINRM
  * __TesteWinRM.ps1__ --> Script para Realizar os testes de conectividade do powershell.

