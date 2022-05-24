<#
    Objetivo: Criação de servidores no VCenter
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>

Write-Host -ForegroundColor Green "========================================= Criação de servidores no VCenter ========================================="

#import de module
Write-Host "`nImportando o modulo do PowerCli"
Import-Module VMware.VimAutomation.Core -ErrorAction SilentlyContinue

Write-Host "`n`n =================================== Captura de informações =================================== " -ForegroundColor Green

$csvInput = Read-Host "Insira o caminho do arquivo csv para a criação dos servidores"
$csvInfo = Import-Csv $csvInput -UseCulture
$senhaVMware = Get-Credential -Message "Insira usuario e senha para acesso ao VMware"

#Flag para saber se teremos servidores Linux no processo de criação
$switchLinux = 0
while ($switchLinux -ne 2){
    $addLinux = {
        Write-Host "`nTerá servidor Linux para instalação?" -ForegroundColor Green
        Write-Host "1 - SIM"
        Write-Host "2 - NÃO"
        $switchLinux = Read-Host "`nSelecione as opções desejadas: [numeros de 1 a 2}"
        switch ($switchLinux) {
            1 { $senhalinux = Get-Credential "root" -Message "Entre com a senha de root do servidor Linux"
                $fileScriptLinux = Read-Host "`n Insira o caminho do arquivo config-ip-linux.sh"
                $switchLinux = 2 }
            2 { Write-Host "Não teremos servidores Linux para instalação" -ForegroundColor Yellow }
            Default { "`n Entrada não é valida `n"
                .$addLinux }
        } #Close Switch
    }# close $addLinux
    .$addLinux
} # close while 

# Trabalhando com o CSV
foreach ($line in $csvInfo){
    $Vcenter = $line.Vcenter
    $Vcenter = $Vcenter.Trim()

    $nameVM = ($line.nameVM).ToUpper()
    $nameVM = $nameVM.Trim()

    $Template = $line.Template
    $Template = $Template.Trim()

    $folder = $line.Folder
    $folder = $folder.Trim()

    $vCPU = $line.vCPU
    $vCPU = $vCPU.Trim()

    $Memory = $line.Memory
    $Memory = $Memory.Trim()

    $Disk1 = $line.Disk1
    $Disk1 = $Disk1.Trim()

    $Disk2 = $line.Disk2
    $Disk2 = $Disk2.Trim()

    $Vlan = $line.Vlan
    $Vlan = $Vlan.Trim()

    $NetAdpt = "Network adapter 1"

    $Cluster = $line.Cluster
    $Cluster = $Cluster.Trim()

    $DataStore = $line.Datastorage
    $DataStore = $DataStore.Trim()

    $SetIP = $line.IP
    $SetIP = $SetIP.Trim()

    $Subnet = $line.Subnet
    $Subnet = $Subnet.Trim()

    $SetDNS1 = ""

    $Gateway = $line.Gateway
    $Gateway = $Gateway.Trim()

    # ============ Criação dos logs ===============
    $logs = "$PSScriptRoot\"+$senhaVMware.UserName.ToUpper().Split("\")[-1]
    if (!(Test-Path -Path $logs)){
        New-Item -ItemType Directory -Path $logs
    }
    $login = $senhaVMware.UserName.ToLower().Split("\")[-1]
    $logsServer = "$logs\$nameVM_$login.txt"

    if (!(Test-Path -Path $logsServer)){
        New-Item -Path $logs -Name "$nameVM_$login.txt" -ItemType File
    }

    Start-Transaction -Path $logsServer -Append
    Get-Date | Select-Object "DateTime"

    # Exibe o conteudo das variaveis
    Write-Host "Dados do servidor que será criado" -ForegroundColor Green
    Write-Host (" Executando o script como: $($senhaVMware.UserName)").ToUpper()
    Write-Host " `n Vcenter: $Vcenter `n"
    Write-Host "Servidor: $nameVM `n"
    Write-Host "Template: $Template `n"
    Write-Host " Folder: $folder `n"
    Write-Host "vCPU: $vCPU`n"
    Write-Host "Memory: $Memory`n"
    Write-Host "Disk1: $Disk1`n"
    Write-Host "Disk2: $Disk2`n"
    Write-Host "VLAN: $Vlan`n"
    Write-Host "Network Adaptor: $NetAdpt`n"
    Write-Host "Cluster: $Cluster`n"
    Write-Host "DataStorage: $DataStore`n"
    Write-Host "IP: $SetIP`n"
    Write-Host "Subnet: $Subnet`n"
    Write-Host "Gateway: $Gateway`n"
    
    Write-Host "`n`n=================== Conectando no $vcenter =======================`n`n" -ForegroundColor Green
    do{
        try{
            Connect-VIServer $vcenter -Credential $senhaVMware -Force
        }catch [System.ServiceModel.Security.SecurityNegotiationException]{
            Write-Host "Realizando nova tentativa de conexão" -ForegroundColor Yellow
        }

        try{
            $lasterror = [string]$Error[0].Exception.GetType().FullName
        }catch [System.Management.Automation.RuntimeException]{
            $lasterror = " "
        }$Error.Clear()
    }until( $lasterror -ne "System.ServiceModel.Security.SecurityNegotiationException")

    if ($Global:DefaultVIServers){
        Write-Host "Conectado com sucesso no $vcenter"
    }else{
        Write-Host "Não foi possivel se conectar, verificar..." -ForegroundColor Yellow
        exit
    }

    # Testando se a VLAN existe
    $testVlan = Get-VMHost -Location $Cluster | Get-VirtualPortGroup -Name $Vlan -ErrorAction SilentlyContinue
    if ($testVlan -like ""){
        Write-Host "`n A Vlan $Vlan não existe no: $Vcenter `n" -ForegroundColor Yellow
        break
    }

    # Testando se o Template existe, caso sim, começa a fazer o deploy
    $testTemplate = Get-Template -Name $Template -ErrorAction SilentlyContinue
    if($testTemplate -like $Template){
        $testVM = Get-VM -Name $nameVM -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Name
        if($testVM -ne $nameVM){
            #data inicio
            Get-Date
            $hostESXi = Get-Cluster -Name $Cluster | Get-VMHost -State Connected | Get-Random
            #$hostESXi = Get-Cluster -Name $Cluster | Get-VMHost -Name "Um ESXi dentro do cluster"
            $dataTot = (80 + $Disk1 + $Disk2 + $Memory)
            $dataTot = [Math]::Round($dataTot)
            Write-Host "`n O total de disco necessario para a criação do servidor $dataTot GB `n" -ForegroundColor Green
            $newDataStore = Get-Datastore -Name $DataStore | Select-Object Name,@{ N = "Capacity(GB) "; E = { [System.Math]::Round($_.CapacityGB,2) }}, @{ N = "FreeSpace(GB)"; E = { [Math]::Truncate($_.FreeSpaceGB - $dataTot) }}, @{ N = "FreeSpacePercent"; E = { [Math]::Round(((100 * ($_.FreeSpaceGB - $dataTot)) / ($_.CapacityGB)),0) }} | Select-Object Name, "FreeSpacePercent" | Where-Object { ($_.FreeSpacePercent) -gt 3} | Sort-Object -Descending -Property "FreeSpacePercent" | Select-Object -Property Name -First 1
            if ($newDataStore -eq $null){
                Write-Host "`n O DataStorage escolhido não possui espaço suficiente para a criação do servidor $nameVM`n" -ForegroundColor Yellow
                Write-Host "`n Escolha outro e coloque na planilha novamente `n" -ForegroundColor Yellow
                Spleep 5
                Break
            }else{
                Write-Host "Iniciando a criação da $nameVM" -ForegroundColor Green

                #Iniciando a criação do servidor Windows
                if($Template -notlike "*RHEL*"){
                    $OSCustomizationSpec = Get-OSCustomizationSpec "Replica_Custom_$nameVM" -ErrorAction SilentlyContinue
                    if ($OSCustomizationSpec -notlike ""){
                        Write-Host "`n Removendo o custom antigo $OSCustomizationSpec `n"
                        Remove-OSCustomizationSpec $OSCustomizationSpec -Confirm:$false
                    }

                    $CustomizationSpec = Get-OSCustomizationSpec | ? { ($_.Name -like "Windows 2016") }
                    if ($CustomizationSpec -eq $null){
                        Write-Host "`n A costumização do Sistema Operacional Windows 2016 não foi encontrado `n" -ForegroundColor Yellow
                        Write-Host "`n Ajustar a variavel $CustomizationSpec `n" -ForegroundColor Yellow
                        Spleep 5
                        Break
                    }

                    #procura o objeto "Custom" no gerenciador de customização
                    $csmSpecMgr = Get-View "CustomizationSpecManager"

                    #Duplica o custom com um novo nome
                    $csmSpecMgr.DuplicateCustomizationSpec($CustomizationSpec.Name, "Replica_Custom_$nameVM")

                    #Aplica a variavel
                    $oscCopy = Get-OSCustomizationSpec -Name "Replica_Custom_$nameVM"
                    $custSpec = Get-OSCustomizationSpec $oscCopy

                    #Muda o custom para IP DHCP
                    $custSpec | Get-OSCustomizationNicMapping | Set-OSCustomizationNicMapping -IpMode UseDhcp -Confirm:$false 
                    if ($SetIP -notlike ""){
                        #Muda o custom para o IP estatico e configura
                        $custSpec | Get-OSCustomizationNicMapping | Set-OSCustomizationNicMapping -IpMode UseStaticIP -IpAddress $SetIP -SubnetMask $Subnet -Dns $SetDNS1 -DefaultGateway $Gateway -Confirm:$false
                    }

                    New-VM $nameVM -OSCustomizationSpec $custSpec -VMHost $hostESXi -Template $Template -Datastore $DataStore -Location $folder

                    #Habilita o Devices.hotPlug
                    $configSpec = New-Object VMware.Vim.VirtualMachineConfigSpec
                    $optionValue = New-Object VMware.Vim.OptionValue
                    $optionValue.Key = "device.hotplug"
                    $optionValue.Value = "TRUE"
                    $configSpec.ExtraConfig = $optionValue
                    $newVM = Get-VM $nameVM | Get-View
                    $newVM.ReconfigVM($configSpec)

                    #Remove o custom clonado
                    Remove-OSCustomizationSpec $custSpec -Confirm:$false
                }else{
                    #Iniciando a criação do servidor Linux
                    New-VM -Name $nameVM -VMHost $hostESXi -Template $Template -Datastore $DataStore -Location $folder -ErrorAction SilentlyContinue

                    #ajustando o nome
                    $newNameLinux = $nameVM.ToLower()
                    $arqIPNome = "$newNameLinux;$SetIP;$Subnet;$Gateway"
                    $scriptLinux = "cd /root && echo '$arqIPNome' > lista_ip.txt && chmod 750 ./config-ip-linux.sh && ./config-ip-linux.sh"

                    #Configurar ip e hostname na VM Linux
                    $testScriptLinux = Get-Item $fileScriptLinux
                    if ( $testScriptLinux -like ""){
                        Write-Host "`n O arquivo $fileScriptLinux não foi encontrado`n" -ForegroundColor Yellow
                    }else{
                        Write-Host "`n Copiando o arquivo $fileScriptLinux para o servidor $nameVM"
                        Spleep 120
                        $Error.Clear()
                        Copy-VMGuestFile -Source $fileScriptLinux -Destination "/root/" -VM $nameVM -LocalToGuest -GuestCredential $senhalinux
                        if ($Error.Count -eq 0){
                            $Error.Clear()
                            #Executa script Linux para configurar o hostname e IP
                            Invoke-VMScript -VM $nameVM -GuestCredential $senhalinux -ScriptText $scriptLinux
                            Invoke-VMScript -VM $nameVM -GuestCredential $senhalinux -ScriptText "rm /root/config-ip-linux.sh"
                            if ($Error.Count -ne 0) {
                                Write-Host "`n Não foi possivel configurar o IP no servidor $nameVM" -ForegroundColor Yellow
                            }
                        }else{
                            Write-Host "`n Não foi possivel copiar o arquivo para o $nameVM" -ForegroundColor Yellow
                        }
                    }
                }

                #Configuração de hardware
                Get-VM -Name $nameVM | Set-VM -NumCpu $vCPU -MemoryGB $Memory -Confirm:$false
                $NumCoresPerSocket = New-Object -TypeName VMware.Vim.VirtualMachineConfigSpec -Property @{"$NumCoresPerSocket" = 1}
                (Get-VM $nameVM).ExtensionData.ReconfigVM_Task($NumCoresPerSocket)

                #Configurando o disco Disk1
                if($Disk1 -eq ""){
                    Write-Host "`n Não foi configurado o disco adicional DISK1 para o $nameVM `n" -ForegroundColor Yellow
                    Spleep 2
                }else{
                    New-HardDisk -VM $nameVM -CapacityGB $Disk1 -Persistence persistent -StorageFormat "Thinck" -Confirm:$false
                }

                #Configurando o disco Disk2
                if($Disk2 -eq ""){
                    Write-Host "`n Não foi configurado o disco adicional DISK2 para o $nameVM `n" -ForegroundColor Yellow
                    Spleep 2
                }else{
                    New-HardDisk -VM $nameVM -CapacityGB $Disk2 -Persistence persistent -StorageFormat "Thinck" -Confirm:$false
                }

                #Ajustando a rede
                Get-VM -Name $nameVM | Get-NetworkAdapter -Name $NetAdpt | Set-NetworkAdapter -NetworkName $Vlan -Type Vmxnet3 -Confirm:$false
                Get-VM -Name $nameVM | Get-NetworkAdapter -Name $NetAdpt | Set-NetworkAdapter -StartConnected:$true -Confirm:$false

                #ligar a VM
                Write-Host "`n Ligando a $nameVM`n" -ForegroundColor Green
                Start-VM $nameVM -Confirm:$false
                Spleep 20
            }
        }else{
            Write-Host "`n O servidor $nameVM já existe, verifique diretamente no Vcenter"
            Get-VM -Name $nameVM
            Spleep 2
        }
    }else{
        Write-Host "`n O template $Template não existe no $Vcenter`n" -ForegroundColor Yellow
        Spleep 2
    }

    #Desconectando do Vcenter
    Write-Host "`n Desconectando do $Vcenter`n" -ForegroundColor Green
    Disconnect-VIServer -Server $Vcenter -Confirm:$false -ErrorAction SilentlyContinue

    Stop-Transcript
    Spleep 2
}

Write-Host "`n Finalizada a criação de todos os servidores`n" -ForegroundColor Green
Pause
