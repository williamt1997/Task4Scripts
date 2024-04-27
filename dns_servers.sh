#! /bin/bash

my_time=$(date +%H)
txt_col='\033[1;33m'
txt_col_rev='\033[0m'
txt_col_inp='\033[1;31m'
txt_col_titl='\033[1;34m'

if [ $my_time -lt 12 ]; then
        grt_time="Good Morning"
elif [ $my_time -le 18 ]; then
        grt_time="Good Afternoon"
elif [ $my_time -le 18 ]; then
        grt_time="Good Evening"
else
        grt_time="Good Night"
fi

echo -n -e "${txt_col}"

while :

do

	echo -e "$grt_time $SUDO_USER, \n\nYou Have Now Entered The DNS Server Configuration Setup!\n\nPlease Follow These Commands To Create And Troubleshoot The DNS Server Creation Stage\n\nEnter The Number [1] To: \t Start The DNS Creation Process \nEnter The Number [2] To: \t Test The Connectivity With The Gateway\nEnter The Number [3] To: \t Test And Verify The DNS Server And Bind Zones \nEnter The Number [4] To: \t Quit\n\n"

	echo -n -e "${txt_col_inp}"
        echo "Please Enter A Number: "
        read usr_input
        echo -n -e "${txt_col}"

	case $usr_input in
		1)
			echo -n -e "${txt_col_titl}"
                        echo -e "Step 1: Installing bind and bind-utils and Via Yum \n---------------------------------\n"
                        echo -n -e "${txt_col}"
                        yum install bind bind-utils
                        sleep 1
                        echo -e "Done! \n\n"

			echo -n -e "${txt_col_titl}"
                        echo -e "Step 2: Assigning Ens33 With A Static IP Via nscli \n---------------------------------\n"
                        echo -n -e "${txt_col}"
                        nmcli connection modify ens33 ipv4.method manual ipv4.addresses 10.8.0.29/16 ipv6.method ignore
                        sleep 1
                        echo -e "Done! \n\n"

			echo -n -e "${txt_col_titl}"
                        echo -e "Step 3: Starting The Bind Services \n---------------------------------\n"
                        echo -n -e "${txt_col}"
                        systemctl enable named
			systemctl start named
			systemctl status named
                        sleep 1
                        echo -e "Done! \n\n"

			echo -n -e "${txt_col_titl}"
                        echo -e "Step 4: Amending The Bind Server Configurations \n---------------------------------\n"
                        echo -n -e "${txt_col}"
                        bash -c 'echo "options {
	directory      \"/var/named\";
        dump-file       \"/var/named/data/cache_dump.db\";
        statistics-file \"/var/named/data/named_stats.txt\";
        memstatistics-file \"/var/named/data/named_mem_stats.txt\";
        secroots-file   \"/var/named/data/named.secroots\";
        recursing-file  \"/var/named/data/named.recursing\";
	recursion yes;
        dnssec-enable yes;
        dnssec-validation yes;
        managed-keys-directory \"/var/named/dynamic\";
        pid-file \"/run/named/named.pid\";
        session-keyfile \"/run/named/session.key\";
	include \"/etc/crypto-policies/back-ends/bind.config\";
	allow-query     { localhost; 10.8.0.0/16; 8.8.8.8; 8.8.4.4; };
};

logging {
	channel default_debug {
		file \"data/named.run\";
		severity dynamic;
	};
};

zone \".\" IN {
	type hint;
	file \"named.ca\";
};

zone \"wjrtscrtask.com\" IN {
	type master;
	file \"wjrtscrtask.com.db\";
	allow-update { none; };
};

zone \"10.8.0.0.in-addr.arpa\" IN {
        type master;
        file \"10.8.0.0.db\";
        allow-update { none; };
};

include \"/etc/named.rfc1912.zones\";
include \"/etc/named.root.key\";" > /etc/named.conf'
                        sleep 1
                        echo -e "Done! \n\n"
			echo -n -e "${txt_col_titl}"
                        echo -e "Step 5: Creating The Bind Zone File For wjrtscrtask.com.db \n---------------------------------\n"
                        echo -n -e "${txt_col}"
			bash -c 'echo "\$TTL 86400
@ IN SOA ns1.wjrtscrtask.com. admin.wjrtscrtask.com. (
2024042601
3600
1800
604800
43200
)
@ IN NS ns1.wjrtscrtask.com.
ns1 IN A 10.8.0.29
www IN A 10.8.0.30
ftp IN CNAME www.wjrtscrtask.com." > /var/named/wjrtscrtask.com.db'
                        sleep 1
                        echo -e "Done! \n\n"

			echo -n -e "${txt_col_titl}"
                        echo -e "Step 6: Creating The Bind Zone For 10.8.0.0.db \n---------------------------------\n"
                        echo -n -e "${txt_col}"
			bash -c 'echo "\$TTL 86400
@ IN SOA ns1.wjrtscrtask.com. admin.wjrtscrtask.com. (
2024042602
3600
1800
604800
86400
)
@ IN NS www.wjrtscrtask.com.
8 IN PTR ns1.wjrtscrtask.com.
100 IN PTR www.wjrtscrtask.com." > /var/named/10.8.0.0.db'
			sleep 1
                        echo -e "Done! \n\n"

			echo -n -e "${txt_col_titl}"
                        echo -e "Step 7: Restarting The Bind Services \n---------------------------------\n"
                        echo -n -e "${txt_col}"
                        systemctl restart named.service
                        sleep 1
                        echo -e "Done! \n\n"

			echo -n -e "${txt_col_titl}"
                        echo -e "Step 8: Configuring The DNS Firewall \n---------------------------------\n"
                        echo -n -e "${txt_col}"
			firewall-cmd --permanent --add-port=53/tcp
			firewall-cmd --permanent --add-port=53/udp
			firewall-cmd --reload
                        sleep 1
                        echo -e "Done! \n\n"

			echo -n -e "${txt_col_titl}"
                        echo -e "Step 9: Connecting DNS To The Gateway Via ip route for testing \n---------------------------------\n"
                        echo -n -e "${txt_col}"
                        ip route add default via 10.8.0.30 dev ens33
                        sleep 1
			echo -e "Done! \n\n"

			echo -n -e "${txt_col_titl}"
                        echo -e "Step 10: Amending resolv.conf \n---------------------------------\n"
                        echo -n -e "${txt_col}"
                   	bash -c 'echo "search dev.easlab.co.uk storage.easlab.co.uk client.easlab.co.uk easlab.co.uk
nameserver 10.8.0.29
nameserver 8.8.8.8
nameserver 8.8.4.4" > /etc/resolv.conf'
			#search dev.easlab.co.uk storage.easlab.co.uk client.easlab.co.uk easlab.co.uk
			#nameserver 10.8.0.1	
                        sleep 1
			echo -e "Done! \n\n"
			;;
		2)
			echo -n -e "${txt_col_titl}"
                        echo "Peforming Ping to google.com from 10.8.0.30 Gateway 5 times \n---------------------------------\n"
                        echo -n -e "${txt_col}"
                        ping -c 5 google.com
                        sleep 1
                        echo -e "Done! \n\n"

                        echo -n -e "${txt_col_titl}"
                        echo "Performing traceroute to google.com from 10.8.0.30 Gateway \n---------------------------------\n"
                        echo -n -e "${txt_col}"
                        traceroute google.com
                        sleep 1

                        echo -n -e "${txt_col_titl}"
                        echo -e "\n\nPerforming curl to google.com from 10.8.0.30 Gateway  \n---------------------------------\n"
                        echo -n -e "${txt_col}"
                        curl google.com
                        sleep 1
			;;

		3)
			echo -n -e "${txt_col_titl}"
                        echo -e "\n\nVerifying DNS Locally Via Dig  \n---------------------------------\n"
                        echo -n -e "${txt_col}"
                        dig www.wjrtscrtask.com
                        sleep 1

			echo -n -e "${txt_col_titl}"
                        echo -e "\n\nVerifying DNS Locally Via nslookup  \n---------------------------------\n"
                        echo -n -e "${txt_col}"
                        nslookup www.wjrtscrtask.com
                        sleep 1
			;;

		4)
			echo -n -e "${txt_col_titl}"
                        echo -e  "\n\ngoodbye $SUDO_USER"
                        echo -n -e "${txt_col_rev}"
                        break
			;;

		*)
			echo -n -e "${txt_col_titl}"
                        echo -e "Unknown Input\n\n"
                        ;;
	esac
        echo -n -e "${txt_col_inp}"
        echo -e "\n\nPress Enter To Continue"
        read
        echo -n -e "${txt_col}"
        echo -e "\n\n"

done
