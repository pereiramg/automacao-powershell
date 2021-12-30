<#
    Objetivo: Configurando o tamanho do log do Cluster
    Version: 1.0
    Autor: Marcelo Galdino Pereira
#>

Write-Host -ForegroundColor Green "========================================= Configurando o tamanho do log do Cluster ========================================="

Set-ClusterLog -Size 1024

Write-Host "Realizado a alteração do tamanho para 1024"

Pause