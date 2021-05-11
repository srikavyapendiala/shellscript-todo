#!/bin/bash
source components/common.sh
Head "Set Hostname and Update Repo"
REPEAT
STAT $?
Head "Install Go Lang"
wget -c https://dl.google.com/go/go1.15.5.linux-amd64.tar.gz -O - | sudo tar -xz -C /usr/local
STAT $?

Head "Set path variables"
export PATH=$PATH:/usr/local/go/bin
source ~/.profile
go version
STAT $?

Head "Make directory"
mkdir ~/go
cd ~/go &&
mkdir src
cd src
STAT $?

GIT_CLONE
STAT $?

Head " Build the Source-code"
export GOPATH=~/go &>>$LOG
depmod && apt install go-dep &>>$LOG
cd login
dep ensure && go get &>>$LOG && go build &>>$LOG
Stat $?


Head "Create login service file"
mv /root/go/src/login/systemd.service /etc/systemd/system/login.service

Head "Start login service"
systemctl daemon-reload && systemctl start login && systemctl status login
STAT $?