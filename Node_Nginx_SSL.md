# Ububtu base setup

sudo apt update
sudo apt install nodejs
sudo apt install npm
sudo apt install nginx

## Node_js

> Steps to deploy a Node.js app to DigitalOcean using PM2, NGINX as a reverse proxy and an SSL from LetsEncrypt

## 1. Sign up for Beget and Create a vps(_)

Link to the page for vps registry
<https://cp.beget.com/cloud/servers/create>

## 2. Create a droplet and log in via ssh(you can select a base, that you need)

 I will be using the root user, but would suggest creating a new user

## 3. Install Node/NPM(if not installed)

```bash
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -

sudo apt install nodejs

node --version
```

## 4. Clone your project from Github

There are a few ways to get your files on to the server, use Git

```bash
git clone yourproject.git
```

### 5. Install dependencies and test app

```bash
cd yourproject
npm install
npm start (or whatever your start command)
# stop app
ctrl+C
```

## 6. Setup PM2 process manager to keep your app running

```bash
sudo npm i pm2 -g
pm2 start app (or whatever your file name)
pm2 startup ubuntu
pm2 status
pm2 logs (Show log stream)
pm2 save
pm2 restart app

# Other pm2 commands
pm2 restart ваше_имя --cron "0 0 * * *" 
pm2 show app
pm2 stop app
pm2 flush (Clear logs)
```

### You should now be able to access your app using your IP and port. Now we want to setup a firewall blocking that port and setup NGINX as a reverse proxy so we can access it directly using port 80 (http)

## 7. Setup ufw firewall(**Отключить при релизе**)

```bash
sudo ufw enable
sudo ufw status
sudo ufw allow ssh 
sudo ufw allow http 
sudo ufw allow https
```

## 8. Install NGINX and configure

```bash
sudo apt install nginx

sudo nano /etc/nginx/sites-available/default
```

Add the following to the location part of the server block

```bash
    server_name yourdomain.com www.yourdomain.com;

    location / {
        proxy_pass http://localhost:5000; #whatever port your app runs on
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
```

```bash
# Check NGINX config
sudo nginx -t

# Restart NGINX
sudo service nginx restart
```

### You should now be able to visit your IP with no port (port 80) and see your app. Now let's add a domain

## 9. Add domain in Digital Ocean

In Digital Ocean, go to networking and add a domain

Add an A record for @ and for www to your droplet

## Register and/or setup domain from registrar

<https://cp.beget.com/domains>
<https://beget.com/ru/kb/how-to/vps/vypusk-i-ustanovka-ssl-sertifikatov-ot-lets-encrypt-na-vps#nginx>

Make sure that there are written in your domain->settings

* ns1.beget.com
* ns2.beget.com
* ns1.beget.pro
* ns2.beget.pro

Editing them might take up to 24 hours

## 10. Add SSL with LetsEncrypt

```bash
sudo apt-get install snapd
sudo snap install core; sudo snap refresh core
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot

sudo certbot --nginx

# Only valid for 90 days, test the renewal process with
certbot renew --dry-run
```

Now visit <https://yourdomain.com> and you should see your Node app
