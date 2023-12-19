#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
MONGO_URL=mongodb.daws74s.online

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "script starts executing at $TIMESTAMP" &>> $LOGFILE

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 ...$R FAILED $N"
        exit 1
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

dnf module disable nodejs -y &>> $LOGFILE

VALIDATE $? "DISABLING" 

dnf module enable nodejs:18 -y &>> $LOGFILE

VALIDATE $? "ENABLING" 

dnf install nodejs -y &>> $LOGFILE

VALIDATE $? "INSTALLING"

id roboshop
if [ $? -ne 0 ]
then
    useradd roboshop
    VALIDATE $? "roboshop user creation"
else
    echo "roboshop user already exists"
fi 

mkdir -p /app

VALIDATE $? "MAKE DIRECTORY" 

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> $LOGFILE

VALIDATE $? "DOWNLOADED CATALOGUE APP" 

cd /app 

unzip -o /tmp/catalogue.zip &>> $LOGFILE

VALIDATE $? "UNZIP THE CATALOGUE"

npm install &>> $LOGFILE

VALIDATE $? "INSTALL DEPENDENCIES" 

cp /home/centos/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service &>> $LOGFILE

VALIDATE $? "COPYING CATALOGUE SERVICE FILE"

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "DEMON"

systemctl enable catalogue &>> $LOGFILE

VALIDATE $? "ENABLE"

systemctl start catalogue &>> $LOGFILE

VALIDATE $? "STARTING"

cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

VALIDATE $? "COPYING MONGODB REPO"

dnf install mongodb-org-shell -y &>> $LOGFILE

VALIDATE $? "INSTALLING MONGODB CLIENT"

mongo --host $MONGO_URL  &>> $LOGFILE

VALIDATE $? "LOADING CATALOGUE INTO MONGODB"
