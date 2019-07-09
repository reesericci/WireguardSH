# WireguardSH | an easy way to create clients in WireGuard

It is a pain to make new clients in WireGuard, that is no more with wireguardsh!

## How to use the script:

1. login as root
2. run the command `curl -L -O https://raw.githubusercontent.com/reesericci/wireguardsh/releases/v1.0/wireguardsh.deb` then run `dpkg -i wireguardsh.deb`
3. Rename all server keys to server_publickey and server_privatekey
3. run wireguard.sh
4. Give it your Client name, IP address for the client, your DNS server address (Setup a pi-hole if you havent already), your public IP, and your WireGuard port.
5. run the curl command every once in a while to keep updated
## Things to note:
The script will create a directory tree of client, keys
Inside the client folder there will be the client configs from the script.
Inside the keys folder there will be a directory tree of server, client.
Inside keys/client there is another tree of public, private.
Inside keys/server there is the same tree.
Inside keys/client/private there are private keys for the client,ect.
It will automattically move all server keys into the keys/server folder
