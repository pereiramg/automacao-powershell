<#
    Objetivo: Instalação do Cluster Microsoft
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>

Write-Host -ForegroundColor Green "========================================= Instalação do Cluster Microsoft ========================================="

#Solicitação do IP do Cluster
$ipCluster = Read-Host "Insira o IP do novo Cluster"
#Realizando os ajustes para o nome padrão do cluster
$clusterName = $env:COMPUTERNAME -replace "^S", "C"

#Criação do cluster com os dados informados
New-Cluster -Name $clusterName -Node $env:COMPUTERNAME -StaticAddress $ipCluster.ToString()

#Montando um case para adicionar mais Node ao Cluster
$switchAddNodes = 0
while ($switchAddNodes -ne 2) {
    $addNodes = {
        Write-Host "`n`n Deseja adicionar mais um Node?"
        Write-Host "1 - SIM"
        Write-Host "2 - NÃO"
        $switchAddNodes = Read-Host "`n`n Selecione as opções desejadas: [numeros de 1 a 2]"
        switch ($switchAddNodes) {
            1 {$newNode = Read-Host "`n`n Insira o nome do servidor para ser adicionado ao Cluster"  
                Add-ClusterNode -Name $newNode.ToString()}
            2 {Write-Host "Não será adicionado mais nenhum servido ao Cluster $clusterName `n`n"}
            Default {"`n Entrada não é valida. `n"
                .$addNodes}
        }
    }
    .$addNodes
}

#Adicionar o Cluster no grupo de segurança
# Veja o nome do seu grupo de segurança que possui permissão
#No meu caso utilizei o nome de exemplo g-srv-cluster
$computerNameCluster = $clusterName + '$'
try {
    Add-ADGroupMember -Identity "g-srv-cluster" -Members $computerNameCluster -ErrorAction Stop
}
catch [System.Management.Automation.RuntimeException] {
    Write-Host "Não foi possivel adicionar a $computerNameCluster no grupo g-srv-cluster"
}

#Alterando o nome das interfaces de rede LAN
#Para não deixar padrão o nome é recomendado alterar para melhor identificação
$nameLan = Read-Host "Insira os 3 primeiros conjuntos da rede LAN. Ex: 10.225.20"
$nameLan += ".*"

$nameOldLan = Get-ClusterNetwork | ?{$_.Address -like $nameLan} | Select-Object name | ForEach-Object {$_.name}
(Get-ClusterNetwork -Name $nameOldLan).Name = "LAN"

#Alterando o nome da interface de rede HB
$switchHB = 0
while ($switchHB -ne 2) {
    $addHB = {
        Write-Host "`n`n Terá interface de HEARTBEAT?"
        Write-Host "1 - SIM"
        Write-Host "2 - NÃO"
        $switchHB = Read-Host "`n`n Selecione as opções desejadas: [numeros de 1 a 2]"
        switch ($switchHB) {
            1 {$nameHB = Read-Host "Insira os 3 primeiros conjuntos da rede HB. Ex: 10.225.20"
                $nameHB += ".*"
                $nameOldHB = Get-ClusterNetwork | ?{$_.Address -like $nameHB} | Select-Object name | ForEach-Object {$_.name}
                (Get-ClusterNetwork -Name $nameOldHB).Name = "HEARTBEAT"}
            2 {Write-Host "Não será configurado a interface HEARTBEAT"}
            Default {"`n Entrada não é valida. `n"
                .$addHB}
        }
    }
    .$addHB
}

#Criando um Group para o cluster
$clusterNameVip = $env:COMPUTERNAME -replace "^S", "V"
$ipClusterVip = Read-Host "Insira o IP do VIP $clusterNameVip"
Add-ClusterGroup -Name $clusterNameVip -Cluster $ipCluster
Add-ClusterResource -Name $clusterNameVip -ResourceType "Network Name" -Group $clusterNameVip
Add-ClusterResource -Name "IP Address $ipClusterVip" -ResourceType "IP Address" -Group $clusterNameVip

$subnetVip = Get-WmiObject Win32_NetworkAdapterConfiguration | where {$_.ipaddress -like $ipCluster | Select IPSubnet | ft -HideTableHeaders | Out-String}
$subnetVip = ($subnetVip -split([char]0x007B) -split(","))[1]

#configurando o IP
Get-ClusterResource -Name "IP Address $ipClusterVip" | Set-ClusterParameter -Multiple @{"Address"=$ipClusterVip;"SubnetMask"=$subnetVip;"EnableDhcp"=0}

#Configurando o NetworkName
Get-ClusterResource -Name $clusterNameVip | Set-ClusterParameter -Multiple @{"DnsName"=$clusterNameVip}

#Inserindo a dependencia
Set-ClusterResourceDependency -Resource $clusterNameVip -Dependency "[IP Address $ipClusterVip]"

Start-ClusterGroup -Name $clusterNameVip

Write-Host "`n`nCluster criado com sucesso`n`n" -BackgroundColor Green

Pause