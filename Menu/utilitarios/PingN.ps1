<#
    Objetivo: Ping sob demanda
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>

Write-Host -ForegroundColor Green "========================================= Ping sob demanda ========================================="

#import das bibliotecas
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function PingResult {
    $allIps = $textBoxHostnameAll.Text.split("`n")
    foreach ($server in $allIps){
        if (![string]::IsNullOrWhiteSpace($server)){
            if (Test-Connection -ComputerName $server -Quiet -Count 1){
                $serverName = [System.Net.Dns]::GetHostAddresses($server)
                $textBoxResultado.AppendText("Servidor $server - $serverName --> respondeu com sucesso" + "`n")
            }else{
                $textBoxResultado.AppendText("Servidor $server não responde" + "`n")
            }
        }
    }
    
}

#Definição das fontes
$fontTittle = New-Object System.Drawing.Font("Time New Romam",14,[System.Drawing.FontStyle]::Bold)
$fontLabel = New-Object System.Drawing.Font("Time New Romam",,[System.Drawing.FontStyle]::Bold)
$fontTextBox = New-Object System.Drawing.Font("Time New Romam",11)

#Criação do formulario
$mainPing = New-Object System.Windows.Forms.Form
$mainPing.Text = "Ping sob demanda"
$mainPing.Size = New-Object System.Drawing.Size(330,560)
$mainPing.StartPosition = "CenterScreen"
$mainPing.AutoScroll = $true
$mainPing.MinimizeBox = $false
$mainPing.MaximizeBox = $false
$mainPing.WindowState = 'Normal'
$mainPing.FormBorderStyle = 'Fixed3D'
$icone = [System.Drawing.Icon]::ExtractAssociatedIcon($PSHOME + "\PowerShell.exe")
$mainPing.Icon = $icone

#Titulo da aplicação
$labelTitle = New-Object System.Windows.Forms.Label
$labelTitle.Location = New-Object System.Drawing.Point(30,20)
$labelTitle.Font = $fontTittle
$labelTitle.Size = New-Object System.Drawing.Size(280,20)
$labelTitle.Text = "Ping sob demanda"
$labelTitle.AutoSize = $true
$mainPing.Controls.Add($labelTitle)

#Label IP/Hostname
$labelHostname = New-Object System.Windows.Forms.Label
$labelHostname.Location = New-Object System.Drawing.Point(20,70)
$labelHostname.Font = $fontLabel
$labelHostname.Text = "IP/HOSTNAME"
$labelHostname.AutoSize = $true
$mainPing.Controls.Add($labelHostname)

#TextBox IP/Hostname Inclusão
$textBoxHostname = New-Object System.Windows.Forms.TextBox
$textBoxHostname.Location = New-Object System.Drawing.Point(20,90)
$textBoxHostname.Size = New-Object System.Drawing.Size(160,40)
$textBoxHostname.Font = $fontTextBox
$mainPing.Controls.Add($textBoxHostname)

#Label IP/Hostname para os testes
$labelHostnameAll = New-Object System.Windows.Forms.Label
$labelHostnameAll.Location = New-Object System.Drawing.Point(20,140)
$labelHostnameAll.Font = $fontLabel
$labelHostnameAll.Text = "IP/HOSTNAME para os testes"
$labelHostnameAll.AutoSize = $true
$mainPing.Controls.Add($labelHostnameAll)

#TextBox IP/Hostname
$textBoxHostnameAll = New-Object System.Windows.Forms.TextBox
$textBoxHostnameAll.Location = New-Object System.Drawing.Point(20,160)
$textBoxHostnameAll.Size = New-Object System.Drawing.Size(280,100)
$textBoxHostnameAll.Font = $fontTextBox
$textBoxHostnameAll.Multiline = $true
$textBoxHostnameAll.ScrollBars = "Vertical"
$textBoxHostnameAll.ReadOnly = $true
$mainPing.Controls.Add($textBoxHostnameAll)

#Botão de incluir os IP/Hostname
$buttonCadastrar = New-Object System.Windows.Forms.Button
$buttonCadastrar.Location = New-Object System.Drawing.Point(200,85)
$buttonCadastrar.Size = New-Object System.Drawing.Size(85,35)
$buttonCadastrar.Text = "Cadastrar Servidor"
$buttonCadastrar.Add_Click({
    $textBoxHostnameAll.AppendText($textBoxHostname.Text + "`n")
    $textBoxHostname.Text = ""
})
$mainPing.Controls.Add($buttonCadastrar)

#Botão executar
$buttonExecutar = New-Object System.Windows.Forms.Button
$buttonExecutar.Location = New-Object System.Drawing.Point(60,275)
$buttonExecutar.Size = New-Object System.Drawing.Size(85,35)
$buttonExecutar.Text = "Executar"
$buttonExecutar.Add_Click({PingResult})
$mainPing.AcceptButton = $buttonExecutar
$mainPing.Controls.Add($buttonExecutar)

#Botão Limpar
$buttonLimpar = New-Object System.Windows.Forms.Button
$buttonLimpar.Location = New-Object System.Drawing.Point(170,275)
$buttonLimpar.Size = New-Object System.Drawing.Size(85,35)
$buttonLimpar.Text = "Limpar"
$buttonLimpar.Add_Click({
    $textBoxResultado.Text = ""
    $textBoxHostnameAll.Text = ""
})
$mainPing.AcceptButton = $buttonLimpar
$mainPing.Controls.Add($buttonLimpar)


#Label Resultado
$labelResultado = New-Object System.Windows.Forms.Label
$labelResultado.Location = New-Object System.Drawing.Point(20,320)
$labelResultado.Font = $fontLabel
$labelResultado.Text = "RESULTADO"
$labelResultado.AutoSize = $true
$mainPing.Controls.Add($labelResultado)

#TextBox Resultado
$textBoxResultado = New-Object System.Windows.Forms.TextBox
$textBoxResultado.Location = New-Object System.Drawing.Point(20,340)
$textBoxResultado.Size = New-Object System.Drawing.Size(280,160)
$textBoxResultado.Font = $fontTextBox
$textBoxResultado.Multiline = $true
$textBoxResultado.ScrollBars = "Vertical"
$textBoxResultado.ReadOnly = $true
$mainPing.Controls.Add($textBoxResultado)

#Exibir formulario
$mainPing.ShowDialog()

