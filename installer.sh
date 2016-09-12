#!/bin/bash
sudo mkdir /etc/efwat

# copy the token fetcher script into the working directory
sudo cp token_fetcher.sh /etc/efwat/token_fetcher.sh
sudo cp ip-checker.sh /etc/efwat/ip-checker.sh
sudo chmod a+x /etc/efwat/token_fetcher.sh
sudo chmod a+x /etc/efwat/ip-checker.sh

sudo apt-get install mosquitto-clients

cd /etc/efwat

while [[ $# -gt 1 ]]
do
key="$1"
case $key in
    -i|--interface)
    INTERFACE_PARAM="$2"
    shift # past argument
    ;;
    -s|--serveradress)
    SERVER_PARAM="$2"
    shift # past argument
    ;;
    -p|--port)
    PORT_PARAM="$2"
    shift # past argument
    ;;
    *)
    # unknown option
    ;;
esac
shift
done

TODATE="$(date +%Y)-$(date +%m)-$(date +%d)"

SCRIPTLOG=runlog

if [ -f $SCRIPTLOG ] ; then
echo "$TODATE [$(date +%T)]: Starting: updateip" >> $SCRIPTLOG
else
echo "$TODATE [$(date +%T)]: Logfile created" >> $SCRIPTLOG
echo "$TODATE [$(date +%T)]: Starting: updateip" >> $SCRIPTLOG
fi

# Create Host and Random password

if [ -z "$INTERFACE_PARAM" ]; then
    INTERFACE=$(ip route get 8.8.8.8 | awk -F"dev " 'NR==1 {split($2,a," ");print a[1]}')
else
    INTERFACE=$INTERFACE_PARAM
fi

if [ -z "$SERVER_PARAM" ]; then
    SERVER="52.209.72.167"
else
    SERVER=$SERVER_PARAM
fi

if [ -z "$PORT_PARAM" ]; then
    PORT=1883
else
    PORT=$PORT_PARAM
fi

echo "$TODATE [$(date +%T)]: Working with device interface $INTERFACE" >> $SCRIPTLOG
echo "$TODATE [$(date +%T)]: Working with server $SERVER" >> $SCRIPTLOG

HOST=$(sudo cat /sys/class/net/$INTERFACE/address | tr : -)
PASS=$(date| sha256sum | base64 | head -c 32)
RANDOM=$(date| sha256sum | base64 | head -c 32)
echo "interface : $INTERFACE"
echo "server : $SERVER"

IP=$(ifconfig $INTERFACE | awk '/inet addr/{print substr($2,6)}')

echo "$TODATE [$(date +%T)]: * Device Current IP $IP" >> $SCRIPTLOG
echo "$TODATE [$(date +%T)]: * Mac address : $HOST" >> $SCRIPTLOG
echo "$TODATE [$(date +%T)]: * Password Has Been Generated" >> $SCRIPTLOG
echo "$TODATE [$(date +%T)]: * Registering Device To efwhat Service" >> $SCRIPTLOG

mosquitto_pub -h $SERVER -p $PORT -m '{"host":"'"$HOST"'","pass":"'"$PASS"'","random":"'"$RANDOM"'"}' -t "register"

#add mosquitto subscribe for a privte chanell if needed

# run script to get token and store it in token file
echo "$TODATE [$(date +%T)]: * Token Been Received" >> $SCRIPTLOG

TOKEN=$(sudo bash token_fetcher.sh $HOST $PASS)
echo "token recived $TOKEN"
echo "$TODATE [$(date +%T)]: * Registering device to efwhat dns" >> $SCRIPTLOG

# register device ip to efwat service
mosquitto_pub -h $SERVER -p $PORT -m '{"host":"'"$HOST"'","token":"'"$TOKEN"'","newIp":"'"$IP"'","random":"'"$RANDOM"'"}' -t "update_record"

echo "$TODATE [$(date +%T)]: * Installing Ip checker daemon" >> $SCRIPTLOG
echo "$TODATE [$(date +%T)]: * Ensuring DHCP hooks" >> $SCRIPTLOG
echo "ip : $IP , token : $TOKEN, host;$HOST, pass:$PASS"

echo "TOKEN=$TOKEN" >> config
echo "SERVER=$SERVER" >> config
echo "PORT=$PORT" >> config
echo "PASS=$PASS" >> config
echo "INTERFACE=$INTERFACE" >> config

# Append the ip-checker to crontab

(crontab -l 2>/dev/null; echo "*/20 * * * * bash /etc/efwat/ip-checker.sh") | crontab -


