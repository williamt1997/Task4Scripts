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
	echo -e "$grt_time $SUDO_USER, \n\nYou Have Now Entered The Network Gateway Configuration Setup!\n\nPlease Follow These Commands To Create And Troubleshoot The Network Creation Stage\n\nEnter The Number [1] To: \t Start The Network, Routing And Gateway Creation Process \nEnter The Number [2] To: \t Check The Network Configurations \nEnter The Number [3] To: \t Check the connectivity to the internet \nEnter The Number [4] To: \t Quit\n\n"
	echo -n -e "${txt_col_inp}"
	echo "Please Enter A Number: "
	read usr_input
	echo -n -e "${txt_col}"

	case $usr_input in
		1)
			echo -n -e "${txt_col_titl}"
			echo -e "Step 1: Creating New Connection [wills_gateway] Via nmcli \n---------------------------------\n"
			echo -n -e "${txt_col}"
			if nmcli connection show | grep -q "wills_gateway"; then
				echo -e "Network Already Exists:\t Deleting Current wills_gateway Network..."
				nmcli connection delete wills_gateway
			fi
			nmcli connection add type ethernet con-name wills_gateway ifname ens35 -- ethernet.mac-address 00:50:56:90:c0:72
			sleep 1
			echo -e "Done! \n\n"
			
			echo -n -e "${txt_col_titl}"
                        echo -e "Step 2: Modifying wills_gateway via nmcli \n---------------------------------\n"
			echo -n -e "${txt_col}"
			nmcli connection modify wills_gateway ipv4.method manual ipv4.addresses 10.8.0.30/16 ipv4.dns 8.8.8.8 ipv4.never-default true ipv6.method ignore ipv4.may-fail false 
			sleep 1
			echo -e "Done! \n\n"
			
			echo -n -e "${txt_col_titl}"
			echo -e "Step 3: Connecting  wills_gateway via nmcli \n---------------------------------\n"
                        echo -n -e "${txt_col}"
                        nmcli connection up wills_gateway
			sleep 1
			echo -e "Done! \n\n"

			echo -n -e "${txt_col_titl}"
                        echo -e "Step 4: Flushing Existing Firewall Rules \n---------------------------------\n"
                        echo -n -e "${txt_col}"
                        iptables -F
			iptables -t nat -F
			iptables -t mangle -F

			iptables -X
			iptables -t nat -X
			iptables -t mangle -X
			sleep 1
			echo -e "Done! \n\n"

			echo -n -e "${txt_col_titl}"
                        echo -e "Step 5: Setting Up Forwarding And Masquerading Between Isolated And External Network \n---------------------------------\n"
                        echo -n -e "${txt_col}"
			firewall-cmd --add-masquerade --permanent
			firewall-cmd --reload
			iptables -t nat -A POSTROUTING -o ens33 -j MASQUERADE
			iptables -A FORWARD -i wills_gateway -j ACCEPT
                        sleep 1
                        echo -e "Done! \n\n"

			echo -n -e "${txt_col_titl}"
                        echo -e "Step 6: Enabling Packet Forwarding \n---------------------------------\n"
                        echo -n -e "${txt_col}"
                        echo "net.ipv4.ip_forward=1" > /etc/sysctl.conf
                        sleep 1
                        echo -e "Done! \n\n"
			;;
		2)
                        echo -n -e "${txt_col_titl}"
                        echo -e "Performing ifconfig \n---------------------------------\n"
                        echo -n -e "${txt_col}"
                        ifconfig
                        sleep 1

                        echo -n -e "${txt_col_titl}"
                        echo -e "\n\nPerforming ip addr show \n---------------------------------\n"
                        echo -n -e "${txt_col}"
                        ip addr show
                        sleep 1
                        ;;
		3)
			echo -n -e "${txt_col_titl}"
			echo -e "Performing ping to google.com five times \n---------------------------------\n"
			echo -n -e "${txt_col}"
			ping -c 5  google.com
			sleep 1

			echo -n -e "${txt_col_titl}"
			echo -e "\n\nPerforming traceroute to google.com  \n---------------------------------\n"
			echo -n -e "${txt_col}"
			traceroute google.com
			sleep 1

			echo -n -e "${txt_col_titl}"
			echo -e "\n\nPerforming curl to google.com  \n---------------------------------\n"
			echo -n -e "${txt_col}"
			curl google.com
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


