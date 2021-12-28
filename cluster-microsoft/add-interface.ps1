<#
    Objetivo: Adicionar as interfaces de rede necessarias para os servidores Cluster
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>


Write-Host -ForegroundColor Green "`n`n ============== Adicionar as interfaces de rede necessarias para os servidores Cluster =================== `n`n"

# Import Module VMware
Import-Module VMware.VimAutomation.Core -EA SilentlyContinue

# Senha de acesso so VMware
Write-Host "========== Senha de acesso ao VMware ============ `n`n"
$senha_vmware = Get-Credential -Message "Insira o usuário e senha de acesso ao VMware: "

#Senha de acesso aos servidores que precisam ser adicionados as interfaces de rede
Write-Host "========== Senha de acesso ao servidor ============ `n`n"
$senha_vmName = Get-Credential -Message "Insira o usuário e senha de acesso ao servidor: "


# Captura das informações de um CSV (nos caso de muitos servidores)
# Nesse mesmo local deixo um modelo para preencher, lemnrando que a separação deve ser por ;
# Exemplo:
# Vcenter;VM_Name;Cluster;VlanHB;IPHeartbeat;MaskHeartbeat;VlanBK;IPBackup;MaskBackup
$pathCSV = Read-Host "Informe o caminho do CSV"
$csvInfo = Import-Csv $pathCSV -UseCulture

# Inicio do loop e as configurações
foreach ($line in $csvInfo) {
    $Vcenter = $line.Vcenter
    $VM_Name = ($line.VM_Name).toUpper()
    $Cluster = $line.Cluster
    $VlanHB = $line.VlanHB
    $IPHeartbeat = $line.IPHeartbeat
    $MaskHeartbeat = $line.MaskHeartbeat
    $VlanBK = $line.VlanBK
    $IPBackup = $line.IPBackup
    $MaskBackup = $line.MaskBackup

    # Conectando ao VMWARE
    Write-Host "====== Conectando ao $Vcenter =============`n`n"
    Connect-VIServer $Vcenter -Credential $senha_vmware

    #Teste se a $VlanHB existe
    Write-Host "========= validando se a $VlanHB existe =============`n`n"
    $testVlan = Get-VMHost -Location $Cluster | Get-VirtualPortGroup -Name $VlanHB -EA SilentlyContinue
    if($testVlan -like "") {
        Write-Host "`r`n"
        Write-Host "`n A Vlan $($VlanHB) não existe no `r`n" -ForegroundColor Red
        Write-Host "`n Vcenter: $($Vcenter) `r`n" -ForegroundColor Red
        sleep 5
    }

    #Teste se a $VlanBK existe
    Write-Host "========= validando se a $VlanBK existe =============`n`n"
    $testVlan = Get-VMHost -Location $Cluster | Get-VirtualPortGroup -Name $VlanBK -EA SilentlyContinue
    if($testVlan -like "") {
        Write-Host "`r`n"
        Write-Host "`n A Vlan $($VlanBK) não existe no `r`n" -ForegroundColor Red
        Write-Host "`n Vcenter: $($Vcenter) `r`n" -ForegroundColor Red
        sleep 5
    }

    # Adicionando a interface de rede HB no servidor
    Write-Host "========= Adicionando a Rede HB =============`n`n"
    Get-VM -Name $VM_Name | New-NetworkAdapter -NetworkName $VlanHB -Type Vmxnet3 -StartConnected:$true -Confirm:$false
    $codeHB = @"
    netsh interface ipv4 set address Ethernet1 static $IPHeartbeat $MaskHeartbeat
    netsh interface set interface name = Ethernet1 newname = HEARTBEAT
"@

    Invoke-VMScript -VM $VM_Name -GuestCredential $senha_vmName -ScriptText $codeHB
    if($Error.Count -ne 0) {
        Write-Host "Não foi possivel configurar o IP de HEARTBEAT no $VM_Name" -ForegroundColor Red
        $Error.Clear()
    }


    # Adicionando a interface de rede BK no servidor
    Write-Host "========= Adicionando a Rede BK =============`n`n"
    Get-VM -Name $VM_Name | New-NetworkAdapter -NetworkName $VlanBK -Type Vmxnet3 -StartConnected:$true -Confirm:$false
    $codeHB = @"
    netsh interface ipv4 set address Ethernet2 static $IPBackup $MaskBackup
    netsh interface set interface name = Ethernet2 newname = BACKUP
"@

    Invoke-VMScript -VM $VM_Name -GuestCredential $senha_vmName -ScriptText $codeHB
    if($Error.Count -ne 0) {
        Write-Host "Não foi possivel configurar o IP de BACKUP no $VM_Name" -ForegroundColor Red
        $Error.Clear()
    }

    # Desconectar do VCenter
    Write-Host "================= Desconectando do $Vcenter ======================`n`n"
    Disconnect-VIServer -Confirm:$false -EA SilentlyContinue
}

Pause