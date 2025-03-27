# Setup PM2 process manager to keep your app running

```
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

Link to the official process manager page
https://pm2.keymetrics.io/