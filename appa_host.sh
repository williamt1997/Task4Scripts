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

	echo -n -e "$grt_time $SUDO_USER, \n\nYou Have Now Entered The App A Host Client Configuration Setup!\n\nPlease Follow These Commands To Create And Troubleshoot The Apps Creation Stage\n\nEnter The Number [1] To: \tConfigure And Create The App \nEnter The Number [2] To: \tRun The App On This Terminal \nEnter The Number [3] To: \tCurl And Communicate With AppB \t\t${txt_col_inp} Alert! AppB Needs To Be Running ${txt_col} \nEnter The Number [4] To: \tTest the gateway and network connection \nEnter The Number [5] To: \tTest the DNS  \nEnter The Number [6] To: \tQuit\n\n"

	echo -n -e "${txt_col_inp}"
        echo "Please Enter A Number: "
        read usr_input
        echo -n -e "${txt_col}"

	case $usr_input in
		1)
			echo -n -e "${txt_col_titl}"
                        echo -e "Step 1: Installing NPM Via Yum \n---------------------------------\n"
                        echo -n -e "${txt_col}"
                        curl -fsSL https://rpm.nodesource.com/setup_22.x | bash -
		       	yum install -y nodejs
                        sleep 1
                        echo -e "Done! \n\n"

			echo -n -e "${txt_col_titl}"
                        echo -e "Step 2: Installing git Via Yum \n---------------------------------\n"
                        echo -n -e "${txt_col}"
                        yum install git
                        sleep 1
                        echo -e "Done! \n\n"

			echo -n -e "${txt_col_titl}"
                        echo -e "Step 3: Cloning App From Github \n---------------------------------\n"
			echo -n -e "${txt_col_inp}"
			echo -e "Please Note That you Will Require My Github Username And Token\nUsername: williamt1997\nToken: Ask William\n---------------------------------\n"
                        echo -n -e "${txt_col}"
                        git clone https://github.com/Enterprise-Automation/trainee-challenge-node-app.git
                        sleep 1
                        echo -e "Done! \n\n"

			echo -n -e "${txt_col_titl}"
                        echo -e "Step 4: Redirecting Into trainee-challenge-node-app \n---------------------------------\n"
                        echo -n -e "${txt_col}"
                        cd trainee-challenge-node-app
			npm install dotenv
                        sleep 1
                        echo -e "Done! \n\n"
			
			echo -n -e "${txt_col_titl}"
                        echo -e "Step 5: Adding Firewall To Port 3546 \n---------------------------------\n"
                        echo -n -e "${txt_col}"
                        firewall-cmd --permanent --add-port=3546/tcp
			firewall-cmd --permanent --add-port=3546/udp
			firewall-cmd --reload
                        sleep 1
                        echo -e "Done! \n\n"
			;;
		2)
			echo -n -e "${txt_col_titl}"
                        echo -e "Step 1: Redirecting Into trainee-challenge-node-app \n---------------------------------\n"
                        echo -n -e "${txt_col}"
                        cd trainee-challenge-node-app
		       	sleep 1
                        echo -e "Done! \n\n"

			echo -n -e "${txt_col_titl}"
			echo -e "Step 2: Amending The PORT And TARGET_URL \n---------------------------------\n"
			echo -n -e "${txt_col}"
			export PORT=3546
			export TARGET_URL=https://jsonplaceholder.typicode.com/users
			sleep 1
			echo -e "Done! \n\n"

			echo -n -e "${txt_col_titl}"
                        echo -e "Step 3: Starting The Application \n---------------------------------\n"
                        echo -n -e "${txt_col}"
                        sleep 1
                        echo "5"
			sleep 1
			echo "4"
			sleep 1
			echo "3"
			sleep 1
			echo "2"
			sleep 1
			echo "1"
			npm start
			;;
		3)
			echo -n -e "${txt_col_titl}"
			echo "Curling And Communicating With AppA Via 10.8.0.97:3546 \n---------------------------------\n"
			echo -n -e "${txt_col}"
			curl 10.8.0.97:3546
			sleep 1
			echo -e "Done! \n\n"
			;;
		4)
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
		5)
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
		6)
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
