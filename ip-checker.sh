#!/bin/bash
# Script that updates the meta information for the referring, public-viewable HTML page

# 1. check if IP changed since last update
# 2. If not, die
# 3. if it has, upload efwhat server

TODATE="$(date +%Y)-$(date +%m)-$(date +%d)"
# DEBUG
SCRIPTLOG= /etc/efwat/runlog

cd /etc/efwat/

if [ -f $SCRIPTLOG ] ; then
echo "$TODATE [$(date +%T)]: Starting: updateip" >> $SCRIPTLOG
else
echo "$TODATE [$(date +%T)]: Logfile created" >> $SCRIPTLOG
echo "$TODATE [$(date +%T)]: Starting: updateip" >> $SCRIPTLOG
fi

source /etc/efwat/config
SERVER_PARAM=$SERVER
INTERFACE_PARAM=$INTERFACE
PORT=$PORT
sudo echo $(ifconfig INTERFACE_PARAM | awk '/inet addr/{print substr($2,6)}') > newip

NEWIP=$(cat newip)
OLDIP=$(cat oldip)

echo "$TODATE [$(date +%T)]: * Previous IP: $OLDIP" >> $SCRIPTLOG
echo "$TODATE [$(date +%T)]: * Current  IP: $NEWIP" >> $SCRIPTLOG

if [ ! "$NEWIP" == "$OLDIP" ] ; then
    echo "new ip has changed" >> $SCRIPTLOG
    TOKEN=$(cat token)
    HOST=$(cat host)
    echo "$TODATE [$(date +%T)]: * Sending IP ip update to efwat" >> $SCRIPTLOG
    curl -k -X POST $SERVER_PARAM/api/update -d host=$HOST -d newIp=$NEWIP -d token=$TOKEN

    mosquitto_pub -h '52.209.72.167' -p 1883 -m '{"host":"'"$HOST"'","token":"'"$TOKEN"'","newIP":"'"$NEWIP"'"}' -t "update_record"

    # if token is out of date then first get a new token and then do the action
fi

sudo rm oldip
sudo mv newip oldip
echo "$TODATE [$(date +%T)]: Finished: updateip" >> $SCRIPTLOG






