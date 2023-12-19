#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
MONGODB_HOST=mongodb.daws74s.online

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

dnf module disable nodejs -y

VALIDATE $? "DISABLING" &>> $LOGFILE

dnf module enable nodejs:18 -y

VALIDATE $? "ENABLING" &>> $LOGFILE

dnf install nodejs -y

VALIDATE $? "INSTALLING" &>> $LOGFILE

useradd roboshop

VALIDATE $? "CREATE ROBOSHOP USER" &>> $LOGFILE

mkdir /app

VALIDATE $? "MAKE DIRECTORY" &>> $LOGFILE

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip

VALIDATE $? "DOWNLOADED CATALOGUE APP" &>> $LOGFILE

cd /app 

unzip /tmp/catalogue.zip

VALIDATE $? "UNZIP THE CATALOGUE"

npm install 

VALIDATE $? "INSTALL DEPENDENCIES" &>> $LOGFILE

cp /home/centos/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service

VALIDATE $? "COPYING CATALOGUE SERVICE FILE"

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "DEMON"

systemctl enable catalogue &>> $LOGFILE

VALIDATE $? "ENABLE"

systemctl start catalogue &>> $LOGFILE

VALIDATE $? "STARTING"

cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo

VALIDATE $? "COPYING MONGODB REPO"

dnf install mongodb-org-shell -y

VALIDATE $? "INSTALLING MONGODB CLIENT"

mongo --host $MONGODB_HOST </app/schema/catalogue.js

VALIDATE $? "LOADING CATALOGUE INTO MONGODB"





