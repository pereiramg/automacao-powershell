<#
    Objetivo: Formatação dos discos em um Cluster
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>

Write-Host -ForegroundColor Green "========================================= Formatação dos discos em um Cluster ========================================="

#Arquivo com os discos para formtação 
# Aqui vamos gerar um arquivo TXT com as essas informações
# Recomendo executar primeiro os discos tipo D e depois os tipo M
Write-Host "layout do arquivo`n"
Write-Host "#disco; -> o numero do disco"
Write-Host "(D)isk ou (M)ount; -> Tipo do disco"
Write-Host "letra; -> Letra da unidade"
Write-Host "label/mount; -> Label do disco"
Write-Host "unidade de alocacao (ex: 64k para SQL ou DEFAULT)"
Write-Host "grupo do cluster`n"

Write-Host "1;D;E;E;64K;GRUPO01"
Write-Host "2;M;E;TEMPDB_DADOS1A;64K;GROUP01"
Write-Host "3;M;E;TEMPDB_LOG01A;64K;GROUP01"
Write-Host "4;D;G;G;64K;GROUP01"
Write-Host "5;D;I;I;64K;GROUP01"
Write-Host "6;D;W;W;DEFAULT;GROUP01"
Write-Host "7;D;Y;QUORUM;DEFAULT`n"
$discosOrigem = Read-Host "Informe o caminho do txt com os dados preenchidos conforme o modelo acima"
$discos = Import-Csv $discosOrigem -Header Number,Type,Letter,Label,Alocation,Group -Delimiter ";"


#Inicializa os discos como GPT
Write-Host "====================== Inicializa os discos como GPT ====================== `n`n"
Get-Disk | Where-Object PartitionStyle -EQ "raw" | Initialize-Disk -PartitionStyle GPT -PassThru

foreach ($line in $discos) {
    $number = $line.Number
    $type = $line.Type
    $letter = $line.Letter
    $label = $line.Label
    $alocation = $line.Alocation

    #Tratamento do tamanho de alocação
    if ($alocation -eq "64k"){
        $alocation = 65536
    }
    if ($alocation -eq "DEFAULT"){
        $alocation = 4096
    }

    #Criando a partição e formatando o disco
    if ($type -eq "D"){
        #Inserir tratamento se o discos já está formatado
        if (!(Get-Partition -DiskNumber $number | Where-Object PartitionNumber -EQ 2)){
            New-Partition -DiskNumber $number -UseMaximumSize -DriveLetter $letter | Format-Volume -FileSystem NFTS -AllocationUnitSize $alocation -NewFileSystemLabel $label -Confirm:$false -ErrorAction SilentlyContinue
        }
    }
}


foreach ($line in $discos) {
    $number = $line.Number
    $type = $line.Type
    $letter = $line.Letter
    $label = $line.Label
    $alocation = $line.Alocation

    #Tratamento do tamanho de alocação
    if ($alocation -eq "64k"){
        $alocation = 65536
    }
    if ($alocation -eq "DEFAULT"){
        $alocation = 4096
    }

    #Criando a partição e formatando o disco
    if ($type -eq "M"){
        #Inserir tratamento se o discos já está formatado
        $mountPath = $($letter + ":\" + $label)
        if (!(Test-Path -Path $mountPath)){New-Item -ItemType Directory -Path $mountPath}
        if (!(Get-Partition -DiskNumber $number | Where-Object PartitionNumber -EQ 2)){
            New-Partition -DiskNumber $number -UseMaximumSize
            Add-PartitionAccessPath -DiskNumber $number -PartitionNumber 2 -AccessPath $mountPath
            Get-Partition -DiskNumber $number -PartitionNumber 2 | Format-Volume -FileSystem NTFS -AllocationUnitSize $alocation -NewFileSystemLabel $label -Confirm:$false -ErrorAction SilentlyContinue
        }
    }
}

Pause