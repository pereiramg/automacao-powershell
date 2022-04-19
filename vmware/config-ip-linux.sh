# Script de substituição/configuração ens192 para eth0. Configuração de ip e hostname
#
tstamp=$(date '+%d%m%y')
linux_ver=$(awk '{print $7}' /etc/redhat-release | awk -F. '{print $1}')
#
    if [ -f /root/lista_ip.txt ];then
        # Verifica se o IP não é um gateway com final 1-10 ou 250, 255
        chk_gtw=$(awk -F\; '{print $2}' /root/lista_ip.txt | awk -F. '{print $NF}')
            case $chk_gtw in
                1|2|3|250|255 ) echo "Possiel gateway na coluna 2, não sera configurado  $ip_addr" && exit 99;;
            esac
        eth_adp=$(ls /sys/class/net | grep eth)
        eth_adp_wc=$(echo $eth_adp | wc -w)
        [[ $eth_adp_wc -gt 1 ]] && echo "Quantidade de eth superior a 1, não será feito" && exit 99
        [[ $eth_adp_wc -eq 0 ]] && echo "Não foi possivel localizar uma eth, não será feito" && exit 99
        #
        eth_ip=$(ip -4 addr show "$eth_adp")
            if [ ! -z "$eth_ip" ];then
                echo "Ja existe ip configurado, não será feito" && exit 99
            fi
    else
        echo "Arquivo com o ip não localizado, não será feito" && exit 99
    fi
    #
    GERA_ETH()
    {
        cd /etc/sysconfig/network-scripts
        file="/root/lista_ip.txt"
        IFS=";"
        while read nome ip_addr mask_addr gw_addr
        do
            echo "TYPE=Ethernet" > ifcfg-${eth_adp}
            echo "BOOTPROTO-static" >> ifcfg-${eth_adp}
            echo "DEFROUTE=yes" >> ifcfg-${eth_adp}
            echo "IPV4_FAILURE_FATAL=no" >> ifcfg-${eth_adp}
            echo "IPV6INIT=no" >> ifcfg-${eth_adp}
            echo "IPV6_AUTOCONF=no" >> ifcfg-${eth_adp}
            echo "IPV6_DEFROUTE=no" >> ifcfg-${eth_adp}
            echo "IPV6_PEERDNS=no" >> ifcfg-${eth_adp}
            echo "IPV6_PEERROUTES=no" >> ifcfg-${eth_adp}
            echo "IPV6_FAILURE_FATAL=no" >> ifcfg-${eth_adp}
            echo "NAME=${eth_adp}" >> ifcfg-${eth_adp}
            echo "DEVICE=${eth_adp}" >> ifcfg-${eth_adp}
            echo "ONBOOT=yes" >> ifcfg-${eth_adp}
            echo "IPADDR=$ip_addr" >> ifcfg-${eth_adp}
            echo "NETMASK=$mask_addr" >> ifcfg-${eth_adp}
            echo "GATEWAY=$gw_addr" >> ifcfg-${eth_adp}
            export nome_s="$nome"
        done <"$file"
    rm -f /root/lista_ip.txt
    }
    #
    case "$linux_ver" in
        6 )
            GERA_ETH
            hostname $nome_s
            echo "NETWORKING=yes" > /etc/sysconfig/network
            echo "HOSTNAME=$nome_s" >> /etc/sysconfig/network
            service network restart ;;
        7)
            GERA_ETH
            hostnamectl set-hostname $nome_s
            systemctl restart network ;;
    esac