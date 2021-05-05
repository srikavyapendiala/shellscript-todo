#!/bin/bash
source components/common.sh
HEAD "Set hostname & update repo"
REPEAT

HEAD "Downloading  Java 11 version to Java 8 "
apt install openjdk-8-jdk >>"${LOG}"

HEAD "Check Java Version"
java -version
STAT $?

HEAD "Clone code from Github"
GIT_CLONE
STAT $?

HEAD "Install Maven "
apt install maven >>"${LOG}"
STAT $?

HEAD "clean package"
mvn clean package >>"${LOG}"
STAT $?

HEAD "Now go to service file"
vi /etc/systemd/system/users.service || exit
STAT $?

HEAD "now reload"
systemctl daemon-reload
STAT $?

HEAD "enable users"
systemctl enable users
STAT $?

HEAD "start users"
systemctl start users
STAT $?

