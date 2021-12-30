<#
    Objetivo: Adicionar os discos no cluster e grupo
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>

Write-Host -ForegroundColor Green "========================================= Adicionar os discos no cluster e grupo ========================================="

#Arquivo com os discos para formatação 
#O arquivo é o mesmo utilizado pelo "format-disk-cluster.txt"
$discosOrigem = Read-Host "Informe o caminho do txt com os dados preenchidos"
$discos = Import-Csv $discosOrigem -Header Number,Type,Letter,Label,Alocation,Group -Delimiter ";"

#Discos disponiveis para adicionar no Cluster
$discosDisponiveis = Get-ClusterAvailableDisk

#Informações dos dicsos a serem adicionados
Write-Host "`nDiscos a serem adicionados: "
foreach ($lineA in $discos) {
    foreach ($lineB in $discosDisponiveis | ?{$_.Number -eq $lineA.Number}) {
        Write-Host Disco: $lineA.Number Letter: $lineA.Label Size: $lineB.Size
    }
}

#Solicita confirmação para continuar
$respostaCont = {
    Write-Host "`n`nConfirma a inclusão dos discos no storage do Cluster?"
    Write-Host "1 - SIM"
    Write-Host "2 - NAO"
    $continuar = Read-Host "`n`nSelecione as opções desejadas: [numeros de 1 a 2]"
    switch ($continuar) {
        1 {Write-Host "Iniciando o processo de inclusão dos discos" }
        2 {Write-Host "O processo não será iniciado" }
        Default {Write-Host "`nA entrada não é valida.`n"
                .$respostaCont}
    }
}
.$respostaCont

if ($continuar -eq "1") {
    #Adicionar os discos ao cluster
    Write-Host "Adicionando os discos no Cluster ...`n"
    foreach ($lineA in $discos) {
        Get-ClusterAvailableDisk | ?{$_.Number -eq $lineA.Number} | Add-ClusterDisk
    }
    foreach ($lineB in $discos) {
        Get-ClusterAvailableDisk | ?{$_.Number -eq $lineB.Number} | Add-ClusterDisk
    }

    #Aguardar todos os discos entrarem online
    while (Get-ClusterResource | ?{$_.ResourceType -like "Physical Disk" -and $_.State -ne "Online"}) {
        sleep -Seconds 2; Write-Host "Aguardando discos Online ..."
    }

    #Informando como ficará o nome dos discos dentro do Cluster
    foreach ($diskNumber in $discosDisponiveis){
        foreach ($resourceLabel in $discos | ?{$_.Number -eq $diskNumber.Number}) {
            $resource = Get-ClusterResource $diskNumber.Name
            if ($resourceLabel.Type -eq "D"){
                $resource.Name = $resourceLabel.Label
            }elseif ($resourceLabel.Type -eq "M") {
                $resource.Name = $resourceLabel.Letter + "_" + $resourceLabel.Label
            }
            Write-Host "Renomeado", $diskNumber.Name, "para", $resource.Name
        }
    }

    #Mover os recursos para os grupos conforme no arquivo txt
    foreach ($lineA in $discos | ?{($_.Group)}) {
        $renomear = ""
        if ($lineA.Type -eq "D") {
            $renomear = $lineA.Label
        }elseif ($lineA.Type -eq "M") {
            $renomear = $lineA.Letter + "_" + $lineA.Label
        }
        if ($renomear) {
            Write-Host "Movendo recurso", $renomear, "para o grupo", $lineA.Group
            Move-ClusterResource -Name $renomear -Group $lineA.Group | Out-Null
        }
    }

    #Adicionando as dependencias de discos Mount Point
    Write-Host "`nAdicionando as dependencias ..."
    foreach ($lineA in $discos | ?{$_.Type -eq "M"}) {
        $temp = $lineA.Letter + "_" + $lineA.Label
        foreach ($lineB in $discos | ?{$_.Type -eq "D" -and $_.Letter -eq $lineA.Letter}) {
            $dep = $lineB.Label
        }
        Add-ClusterResourceDependency $temp $dep
    }

    #Configurando o disco QUORUM
    Set-ClusterQuorum -DiskWitness "QUORUM"
}

Pause