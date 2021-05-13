#!/bin/bash

source components/common.sh

HEAD "Set Hostname and Update Repo"
REPEAT
STAT $?

HEAD "Install Go Lang"
wget -c https://dl.google.com/go/go1.15.5.linux-amd64.tar.gz -O - | sudo tar -xz -C /usr/local
STAT $?

HEAD "Set path variables"
export PATH=$PATH:/usr/local/go/bin
source ~/.profile
go version
STAT $?

HEAD "Make directory"
mkdir ~/go
cd ~/go
mkdir src
cd src
STAT $?

HEAD "Clone code"
git clone "https://github.com/srikavyapendiala/login.git" &>>${LOG}
STAT $?

HEAD "Export go path in directory"
export GOPATH=~/go
depmod && apt install go-dep &>>$LOG
cd login
dep ensure && go get &>>$LOG && go build &>>$LOG
Stat $?

HEAD "Create login service file"
mv /root/go/src/login/systemd.service /etc/systemd/system/login.service

HEAD "Replace Ip with DNS Names"
sed -i -e 's/Environment=USERS_API_ADDRESS=http://172.31.17.148:8080/Environment=USERS_API_ADDRESS=users.kavya.website:8080/g' /etc/systemd/system/login.service

HEAD "Start login service"
HEAD "Start login service"
systemctl daemon-reload && systemctl start login && systemctl status login
STAT $?
