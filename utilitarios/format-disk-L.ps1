<#
    Objetivo: Formatar o disco L:\
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>

Write-Host -ForegroundColor Green "========================================= Formatar o disco L:\ ========================================="

# Solicitando o arquivo com os servidores
$entradaServidores = Get-Content (Read-Host "Insira o caminho e o nome do txt com os servidores: Ex: c:\temp\servidores.txt")

#Credenciais de acesso aos servidores
$acessoServidores = Get-Credential -Message "Insira as credencias de acesso aos servidores"

Write-Host -ForegroundColor Green "`n========================================= Executando as alteracoes ========================================="
Invoke-Command -ComputerName $entradaServidores -Credential $acessoServidores -ScriptBlock{
    if (Test-Path L:\){
        Write-Host "A unidade L já existe"
    }else{

        #Inicializa os discos como MBR
        Write-Host "================== Inicializa os discos como MBR ================`n`n" -ForegroundColor Green
        Get-Disk | where PartitionStyle -EQ 'raw' | Initialize-Disk -PartitionStyle MBR -PassThru

        #Variaveis
        $number = Get-Disk | Select-Object Number -ExpandProperty Number
        $diskSize = 10
        $Letter = "L"
        $alocation = 4096
        $Label = "IISLog"
        $IISLogDir = "L:\IISLog"
        
        Write-Host "====================== Formatando o Disco ==================`n`n" -ForegroundColor Green
        for ($disco = 0; $disco -lt $number.Length; $disco++){

            if (Get-Disk -Number $disco | Where-Object PartitionStyle -EQ GPT){
                $partition = Get-Disk -Number $disco | Get-Partition | Where-Object PartitionNumber -EQ 2
            }else{
                $partition = Get-Disk -Number $disco | Get-Partition
            } # Fim Else

            if($partition -eq $null -and (Get-Disk -Number $disco | Select-Object Size -ExpandProperty Size) / 1GB -eq $diskSize){
                if(Get-Disk -Number $disco | Where-Object IsOffline -EQ $true){
                    Set-Disk -Number $disco -IsOffline $false
                    Set-Disk -Number $disco -IsReadOnly $false
                } # Fim If
                
                New-Partition -DiskNumber $disco -UseMaximumSize -DriveLetter $Letter | Format-Volume -FileSystem NTFS -AllocationUnitSize $alocation -NewFileSystemLabel $Label -Confirm:$false -ErrorAction SilentlyContinue
                New-Item -Path $IISLogDir -ItemType Directory -Force -ErrorAction SilentlyContinue
                Break
            } # fim if

        } # fim for

    } # fim else
} # fim invoke-command
