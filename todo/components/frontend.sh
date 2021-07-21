#!/bin/bash

DOMAIN="kavya.website"

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

HEAD "switch to html directory"
cd /var/www/html || exit
STAT $?

HEAD "make todo directory and switch"
mkdir vue && cd vue
STAT $?

HEAD "Clone code from Github"
GIT_CLONE
STAT $?

HEAD "Install Npm"
npm install &>>${LOG}
STAT $?

HEAD "Run build"
BUILD
STAT $?

HEAD "Change root path in nginx"
sed -i -e 's+root /var/www/html+root /var/www/html/vue/frontend/dist+g' /etc/nginx/sites-available/default
STAT $?

Head "Update Nginx Configuration"
mv todo.conf /etc/nginx/sites-enabled/todo.conf
for comp in login todo ; do
  sed -i -e "/$comp/ s/localhost/${comp}.${DOMAIN}/" /etc/nginx/sites-enabled/todo.conf
done
Stat $?

HEAD "Restart Nginx"
systemctl restart nginx
STAT $?

HEAD "run npm start"
npm start
STAT $?
