# efwat
A dynamic IP service for IoT device - connect to your device by host name 

# Installation 

>client : apt-get install efwat -i <network_interface> -s <server_address> 
  - default sets to active interface and efwat server 

>server : npm install efwat-server

# Usage
>efwat provide a default implementation of a secure DNS wrap of Amazon Route53
=======
git clone for this project

** will be installed as apt-get package  in the future 
>client : sudo bash install.sh  -i <network_interface> -s <server_address> 
  - default sets to active interface and efwat server 
  
** will be npm installed in the future
>server : npm install efwat-server

efwat consists of client and server side : 

client - a debian package for identifying change in ip address of the device it's been installed on.
  once a change has been detected efwhat updates the server with the new ip. 
+ after installation,a register request is been send to the server
+ the register request pass the device active network interface's mac address as the device host name and generate a random password
+ the server store the the host name and the hashed password and return a jwt
+ each device ip update request, the token is being verified 
+ after installation the package will make sure once the device received a new ip, the DNS server will be updated accordingly 
      
server - Receives ip changes and updates the DNS server after client authentication  
+ contains a registration and authentication using jwt
+ updates DNS server - Amazon Route53 API - for any given ip update
    
    







