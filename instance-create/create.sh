#!/bin/bash

# Authorize TCP, SSH & ICMP for default Security Group
#ec2-authorize default -P icmp -t -1:-1 -s 0.0.0.0/0
#ec2-authorize default -P tcp -p 22 -s 0.0.0.0/0

# The Static IP Address for this instance:
IP_ADDRESS=`cat ~/.ec2/ip_address`

# Create new t1.micro instance using ami-74f0061d (Basic 64-bit Amazon Linux AMI 2010.11.1 Beta)
# using the default security group and a 16GB EBS datastore as /dev/sda1.
# EC2_INSTANCE_KEY is an environment variable containing the name of the instance key.
# --block-device-mapping ...:false to leave the disk image around after terminating instance
EC2_RUN_RESULT=`ec2-run-instances --instance-type t1.micro --group default --key $EC2_INSTANCE_KEY --block-device-mapping "/dev/sda1=:16:true" --instance-initiated-shutdown-behavior stop --user-data-file instance_installs.sh ami-74f0061d`

INSTANCE_NAME=`echo ${EC2_RUN_RESULT} | sed 's/RESERVATION.*INSTANCE //' | sed 's/ .*//'`

ec2-associate-address $IP_ADDRESS -i $INSTANCE_NAME

echo
echo Instance $INSTANCE_NAME has been created and assigned static IP Address $IP_ADDRESS
echo

# Since the server signature changes each time, remove the server's entry from ~/.ssh/known_hosts
# Maybe you don't need to do this if you're using a Reserved Instance?
ssh-keygen -R $IP_ADDRESS

# SSH into my BRAND NEW EC2 INSTANCE! WooHoo!!!
ssh -i $EC2_HOME/$EC2_INSTANCE_KEY.pem ec2-user@$IP_ADDRESS
