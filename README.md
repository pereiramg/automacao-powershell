# Automacao Powershell
O projeto visa criar diversos scritps em PowerShell para realizar instalação de pacotes e correção de problemas no Windows Server 2012/2016/2019

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

* ### iis
  * __DisableDeleteOptionsHTTPVerbs.ps1__ --> Script para efetuar o Disable o Delete e Options no HTTP Verbs IIS no IIS. Precisa criar um txt com os nomes dos servidores.
         
         
