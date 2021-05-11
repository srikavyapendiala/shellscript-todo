#!/bin/bash
source components/common.sh
HEAD "Set hostname & update repo"
REPEAT
HEAD "Install Nginx"
apt install nginx -y &>>"${LOG}"
HEAD "Start Nginx"
systemctl start nginx
HEAD "Install Node & Nginx"
NPM
STAT $?
HEAD "switch to html directory "
cd /var/www/html
STAT $?
HEAD "switch to vue directory"
mkdir vue && cd vue
STAT $?
HEAD "Clone code from Github"
GIT_CLONE
STAT $?
HEAD "Switch to frontend Directory"
cd frontend
STAT $?
HEAD "Install Npm"
npm install >>"${LOG}"
STAT $?
HEAD "Run build"
BUILD
STAT $?
HEAD "Change root path in nginx"
sed -i -e 's+root /var/www/html+root /var/www/html/vue/frontend/dist+g' /etc/nginx/sites-available/default
STAT $?
HEAD "Restart Nginx"
systemctl restart nginx
STAT $?
HEAD "run npm start"
npm start
STAT $?