#should be run with two params : userName and password
# which the user is the device id and password should be randomly created

#curl -k -X POST http://efwatns1.efwat.com:3000/authenticate -d host=$1 -d pass=$2

mosquitto_sub -h '52.209.72.167' -p 1883 -t "authenticate_"$1 > token &

mosquitto_pub -h '52.209.72.167' -p 1883 -m '{"host":"'"$1"'","pass":"'"$2"'"}' -t "authenticate"

sleep 2

echo $(cat token)
#rm token
exit 0

