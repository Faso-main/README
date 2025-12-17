# Wireguard usage snippet 
```bash
sudo apt install wireguard
```

## Copy the config file to WireGuard directory
```bash
sudo cp ~/Downloads/your-config.conf /etc/wireguard/
```

## Make it readable only by root
```bash
sudo chmod 600 /etc/wireguard/your-config.conf
```

## Start the VPN (using config file named wg0.conf)
```bash
sudo wg-quick up wg0
```

## Stop the VPN
```bash
sudo wg-quick down wg0
```

## Check status
```bash
sudo wg show
```

## See active connections
```bash
ip addr show wg0
```

## Enable at boot
```bash
sudo systemctl enable wg-quick@wg0
```
