#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "script starts executing at $TIMESTAMP" &>> $LOGFILE

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 ...$R FAILED $N"
    else
        echo -e "$2 ...$G SUCCESS $N"
    fi
}


if [ $ID -ne 0 ]
then
    echo -e "$R not a root user $N"
    exit 1
else
    echo -e "$G root user $N"
fi


cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

VALIDATE $? "COPIED"

dnf install mongodb-org -y &>> $LOGFILE

VALIDATE $? "Installed"

systemctl enable mongod &>> $LOGFILE

VALIDATE $? "Enabled"

systemctl start mongod &>> $LOGFILE

VALIDATE $? "Started"sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf

VALIDATE $? "Remote access to mongodb"

systemctl restart mongod &>> $LOGFILE

VALIDATE $? "Restarting"




