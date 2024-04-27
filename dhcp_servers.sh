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
	echo -e "$grt_time $SUDO_USER, \n\nYou Have Now Entered The DHCP Server Configuration Setup!\n\nPlease Follow These Commands To Create And Troubleshoot The DHCP Server Creation Stage\n\nEnter The Number [1] To: \t Start The DHCP Creation Process \nEnter The Number [2] To: \t Test The Connectivity With The Gateway \nEnter The Number [3] To: \t Quit\n\n"

	echo -n -e "${txt_col_inp}"
        echo "Please Enter A Number: "
        read usr_input
        echo -n -e "${txt_col}"

	case $usr_input in
		1)
			echo -n -e "${txt_col_titl}"
			echo -e "Step 1: Installing dhcp-server Via Yum \n---------------------------------\n"
			echo -n -e "${txt_col}"
			yum install dhcp-server
			sleep 1
			echo -e "Done! \n\n"

			echo -n -e "${txt_col_titl}"
                        echo -e "Step 2: Assigning Ens33 With A Static IP Via nscli \n---------------------------------\n"
                        echo -n -e "${txt_col}"
                        nmcli connection modify ens33 ipv4.method manual ipv4.addresses 10.8.0.90/16 ipv4.dns "8.8.8.8 8.8.4.4"
                        sleep 1
                        echo -e "Done! \n\n"

			echo -n -e "${txt_col_titl}"
                        echo -e "Step 3: Configuring DHCP Server \n---------------------------------\n"
                        echo -n -e "${txt_col}"
                        bash -c 'echo "ddns-update-style none;
authoritative;
subnet 10.8.0.0 netmask 255.255.0.0 {
	range 10.8.0.91 10.8.0.141;
	option routers 10.8.0.30;
	option subnet-mask 255.255.0.0;
	option domain-name-servers 10.8.0.29, 8.8.8.8, 8.8.4.4;
}" > /etc/dhcp/dhcpd.conf'
                        sleep 1
                        echo -e "Done! \n\n"

			echo -n -e "${txt_col_titl}"
                        echo -e "Step 4: Starting And Enabling The DHCP Service \n---------------------------------\n"
                        echo -n -e "${txt_col}"
                        systemctl enable dhcpd
			systemctl start dhcpd
			systemctl status dhcpd
                        sleep 1
                        echo -e "Done! \n\n"

			echo -n -e "${txt_col_titl}"
                        echo -e "Step 5: Configuring The DHCP Firewall \n---------------------------------\n"
                        echo -n -e "${txt_col}"
                        firewall-cmd --add-service=dhcp --permanent
                        firewall-cmd --reload
                        sleep 1
                        echo -e "Done! \n\n"

			echo -n -e "${txt_col_titl}"
                        echo -e "Step 6: Connecting DHCP To The Gateway Via ip route for testing \n---------------------------------\n"
                        echo -n -e "${txt_col}"
                        ip route add default via 10.8.0.30 dev ens33
			sleep 1
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
		
