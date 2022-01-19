<#
    Objetivo: Projeto Telnet
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

#Função para realizar o telnet em linux
function telnet_linux($origem, $destino, $porta, $senha) {

    Import-Module -Name Posh-SSH
    Remove-SSHTrustedHost "$origem"
    $server_linux = New-SSHSession -ComputerName $origem -Credential $senha -AcceptKey:$true
    $resultado_linux = Invoke-SSHCommand $server_linux.SessionId -Command "echo exit | telnet $destino $porta"
    if ($server_linux){ Remove-SSHSession $server_linux.SessionId}
    Return $resultado_linux
}

#função para realizar o telnet em windows
function telnet($origem, $destino, $porta, $senha) {
    Invoke-Command -ComputerName $origem -Credential $senha -ScriptBlock{
        #Validação do IP e DNS
        try{
            $ip = [System.Net.Dns]::GetHostAddresses($Using:destino)
            Select-Object IPAddressToString -ExpandProperty IPAddressToString
            if($ip.GetType().Name -eq "Object[]"){
                $ip = $ip[0]
            }
        } catch {
            $erro_ip = "Possivelmete o $Using:destino está errado"
            Return $erro_ip
        }
        $tcpClient = New-Object Net.Sockets.TcpClient
        try{
            $tcpClient.Connect($ip,$Using:porta)
        }catch {}

        if($tcpClient.Connected){
            $tcpClient.Close()
            $msg = "A porta $Using:porta foi conectado com sucesso"
        }
        else{
            msg = "A porta $Using:porta no $ip nao conectou"
        }
        Return $msg
    }
}

#Criação do formulario
$form_1 =  New-Object System.Windows.Forms.Form
$form_1.Text = 'Teste de conectividade de portas'
$form_1.Size = New-Object System.Drawing.Size(650,530)
$form_1.StartPosition = 'CenterScreen'
$form_1.AutoScroll = $true
$form_1.MinimizeBox = $false
$form_1.MaximizeBox = $false
$form_1.WindowState = 'Normal'
$form_1.FormBorderStyle = 'Fixed3D'
$icone = [System.Drawing.Icon]::ExtractAssociatedIcon($PSHOME + ".\PowerShell.exe")
$form_1.Icon = $icone

# Criação do titulo da aplicação
$label_01 = New-Object System.Windows.Forms.Label
$label_01.Location = New-Object System.Drawing.Point(10,20)
$font_titulo = New-Object System.Drawing.Font("Times New Romam",16,[System.Drawing.FontStyle]::Bold)
$label_01.Font = $font_titulo
$label_01.Size = New-Object System.Drawing.Size(280,20)
$label_01.Text = 'Teste de Conectividade de porta com Telnet'
$label_01.AutoSize = $true
$form_1.Controls.Add($label_01)

#Fonte padrão dos demais Label
$font_padrao = New-Object System.Drawing.Font("Times New Romam",,[System.Drawing.FontStyle]::Bold)

#Font padrão dos textbox
$font_textbox =  New-Object System.Drawing.Font("Times New Romam",12)

#Label de IP de Origem
$label_iporigem = New-Object System.Windows.Forms.Label
$label_iporigem.Location = New-Object System.Drawing.Point(30,100)
$label_iporigem.Text = 'IP ORIGEM'
$label_iporigem.AutoSize = $true
$label_iporigem.Font = $font_padrao
$form_1.Controls.Add($label_iporigem)

#Caixa de texto IP ORIGEM
$textbox_iporigem = New-Object System.Windows.Forms.TextBox
$textbox_iporigem.Location = New-Object System.Drawing.Point(30,125)
$textbox_iporigem.Size = New-Object System.Drawing.Size(140,40)
$textbox_iporigem.Font = $font_textbox
$form_1.Controls.Add($textbox_iporigem)

#Label de IP de Destino
$label_ipdestino = New-Object System.Windows.Forms.Label
$label_ipdestino.Location = New-Object System.Drawing.Point(200,100)
$label_ipdestino.Text = 'IP DESTINO'
$label_ipdestino.AutoSize = $true
$label_ipdestino.Font = $font_padrao
$form_1.Controls.Add($label_ipdestino)

#Caixa de texto IP DESTINO
$textbox_ipdestino = New-Object System.Windows.Forms.TextBox
$textbox_ipdestino.Location = New-Object System.Drawing.Point(200,125)
$textbox_ipdestino.Size = New-Object System.Drawing.Size(140,40)
$textbox_ipdestino.Font = $font_textbox
$form_1.Controls.Add($textbox_ipdestino)

#Label da PORTA
$label_porta = New-Object System.Windows.Forms.Label
$label_porta.Location = New-Object System.Drawing.Point(370,100)
$label_porta.Text = 'PORTA'
$label_porta.AutoSize = $true
$label_porta.Font = $font_padrao
$form_1.Controls.Add($label_porta)

#Caixa de texto PORTA
$textbox_porta = New-Object System.Windows.Forms.TextBox
$textbox_porta.Location = New-Object System.Drawing.Point(370,125)
$textbox_porta.Size = New-Object System.Drawing.Size(140,40)
$textbox_porta.Font = $font_textbox
$form_1.Controls.Add($textbox_porta)

#Criação do grupo do Radio Button
$groupBox = New-Object System.Windows.Forms.GroupBox
$groupBox.Location = '170,170'
$groupBox.Size = '250,70'
$groupBox.Text = 'Selecione o Sistema Operacional ORIGEM'

#Criação dos Radio Buttons
$radioButton1 = New-Object System.Windows.Forms.RadioButton
$radioButton1.Location = '50,30'
$radioButton1.Size = '70,20'
$radioButton1.Checked = $true
$radioButton1.Text = 'windows'

$radioButton2 = New-Object System.Windows.Forms.RadioButton
$radioButton2.Location = '150,30'
$radioButton2.Size = '70,20'
$radioButton2.Checked = $false
$radioButton2.Text = 'linux'

#Adicionando os Radio Buttons ao GroupBox
$groupBox.Controls.AddRange(@($radioButton1,$radioButton2))

#Adicionando o groupbox ao formulario
$form_1.Controls.AddRange(@($groupBox))

#TextBoxResultado
$textbox_resultado = New-Object System.Windows.Forms.TextBox
$textbox_resultado.Location = New-Object System.Drawing.Point(30,260)
$textbox_resultado.Size = New-Object System.Drawing.Size(480,200)
$textbox_resultado.Multiline = $true
$textbox_resultado.ScrollBars = 'Vertical'
$form_1.Controls.Add($textbox_resultado)

#Botão de CONECTAR
$conectar_button = New-Object System.Windows.Forms.Button
$conectar_button.Location = New-Object System.Drawing.Point(550,120)
$conectar_button.Text = 'CONECTAR'
#$conectar_button.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form_1.AcceptButton = $conectar_button
$form_1.Controls.Add($conectar_button)
$conectar_button.Add_Click({
    $senha = Get-Credential -Message "Insira usuario e senha para acesso ao servidor de origem"
    if($radioButton1.Checked){
        $resultado_telnet = telnet -origem $textbox_iporigem.Text -destino $textbox_ipdestino.Text -porta $textbox_porta.Text -senha $senha
        $textbox_resultado.AppendText($resultado_telnet + "`n")
    }elseif ($radioButton2.Checked) {
        $resultado_telnet = telnet_linux -origem $textbox_iporigem.Text -destino $textbox_ipdestino.Text -porta $textbox_porta.Text -senha $senha
        $textbox_resultado.AppendText($resultado_telnet.host + "`n")
        if (![String]::IsNullOrEmpty($resultado_telnet.Output)) {
            $textbox_resultado.AppendText("A porta " + $textbox_porta.Text + " foi conectado com sucesso `n")
        }else {
            $textbox_resultado.AppendText("A porta " + $textbox_porta.Text + " no " + $textbox_ipdestino.Text + " nao conectou `n")
        }
    }
})

#Picture Box
$photo_windows = [System.Drawing.Image]::FromFile("$PSScriptRoot\windows.jpg")
$photo_linux = [System.Drawing.Image]::FromFile("$PSScriptRoot\linux.jpg")
$picture_box1 = New-Object System.Windows.Forms.PictureBox
$picture_box1.Location = '30,140'
$picture_box1.Size = '130,130'
$picture_box1.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::Zoom
$picture_box1.Image = $photo_windows
$form_1.Controls.Add($picture_box1)

$picture_box2 = New-Object System.Windows.Forms.PictureBox
$picture_box2.Location = '450,155'
$picture_box2.Size = '130,100'
$picture_box2.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::Zoom
$picture_box2.Image = $photo_linux
$form_1.Controls.Add($picture_box2)

#Força a janela abrir em cima das demais
#$form_1.TopMost = $true

#Definir o foco na caixa de texto ORIGEM
$form_1.add_shown({$textbox_iporigem.Select()})

#Metodo de deixar o formulario ativo
#$form_1.add_shown({$form_1.Activate()})

#Exibir o formulario criado
$result = $form_1.ShowDialog()

