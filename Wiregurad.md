# Wireguard usage snippet 

## Copy the config file to WireGuard directory
sudo cp ~/Downloads/your-config.conf /etc/wireguard/

## Make it readable only by root
sudo chmod 600 /etc/wireguard/your-config.conf

## Start the VPN (using config file named wg0.conf)
sudo wg-quick up wg0

## Stop the VPN
sudo wg-quick down wg0

## Check status
sudo wg show

## See active connections
ip addr show wg0

## Enable at boot
sudo systemctl enable wg-quick@wg0 
