#!/bin/bash
num1=$1
num2=$2
VALIDATE(){
    if [$num1==0 || $num2==0 ]
    then 
        echo "not possible to proceed"
        exit
    else
        echo "proceed for further process"
    fi
}

yum install mysql -y
VALIDATE $? "my number is coming"

yum install git -y
VALIDATE $? "my number is coming fast"

