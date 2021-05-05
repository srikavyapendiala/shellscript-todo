#!/bin/bash
source components/common.sh
REPEAT

HEAD "Install redis server"
sudo apt install redis-server
STAT $?

HEAD "Change ip address in redis config file"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis/redis.conf
STAT $?

HEAD "Restart redis server"
systemctl restart redis && systemctl status redis
STAT $?

