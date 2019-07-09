
#!/bin/bash
k="/etc/wireguard/keys"
c="/etc/wireguard/client"
pkg="qrencode"
# Check if the current user is not root (it must be root)
if [ "$USER" != "root" ]; then
echo "Please run as root (type in sudo su then run the script)";
else
#-----Check If qrencode is installed-----------------
if [ ! apt-get -qq install $pkg; ] then
  apt install '$pkg'
fi
# done checking
#-------------CHECK DIRECTORY TREE-----------------

if [ ! -d "$k" ]; then
  mkdir /etc/wireguard/keys
  mkdir /etc/wireguard/keys/server
  mkdir /etc/wireguard/keys/client
  mkdir /etc/wireguard/keys/client/public
  mkdir /etc/wireguard/keys/client/private
  mkdir /etc/wireguard/keys/server/public
  mkdir /etc/wireguard/keys/server/private
  mv /etc/wireguard/server_publickey /etc/wireguard/keys/server/public
  mv /etc/wireguard/server_privatekey /etc/wireguard/keys/server/private
fi
if [ ! -d "$c" ]; then
  mkdir /etc/wireguard/client
fi
#-------------END CHECK DIRECTORY TREE-----------------

#-------------INPUT-----------------
read -p "Client name: " client
read -p "IP address: " ipaddr
read -p "DNS Server (Pi-hole) Address: " dns
read -p "Your public IP: " pip
read -p "Your WireGuard Port: " port
#-------------END INPUT-----------------
cd /etc/wireguard
umask 077
#-------------KEYS-----------------
wg genkey | tee ${client}_privatekey.txt | wg pubkey > ${client}_publickey.txt
mv ${client}_privatekey.txt /etc/wireguard/keys/client/private
mv ${client}_publickey.txt /etc/wireguard/keys/client/public
cprivatekey=`cat /etc/wireguard/keys/client/private/${client}_privatekey.txt`
cpublickey=`cat /etc/wireguard/keys/client/public/${client}_publickey.txt`
sprivatekey=`cat /etc/wireguard/keys/server/private/server_privatekey.txt`
spublickey=`cat /etc/wireguard/keys/server/public/server_publickey.txt`
#-------------END KEYS-----------------

#-------------CONFIG-----------------
echo '[Peer]
#'$client'
PublicKey = '$cpublickey'
AllowedIPs = '$ipaddr'/32, '$dns'/32 
PersistentkeepAlive = 60' >> wg0.conf
touch /etc/wireguard/client/'$client'.conf
echo '[Interface]
Address = '$ipaddr'/32
DNS = '$dns' 
PrivateKey = '$cprivatekey'

[Peer]
PublicKey = '$spublickey'
Endpoint = '$pip':'$port'
AllowedIPs = 192.168.1.0/24
PersistentkeepAlive = 60' > /etc/wireguard/client/${client}.conf
qrencode -t ansiutf8 < /etc/wireguard/client/${client}.conf
echo 'Scan the QR code in the WireGuard app or transfer the config file at /etc/wireguard/client/'$client'.conf'
#-------------END CONFIG-----------------
fi
