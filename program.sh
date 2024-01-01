#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

echo "enter your name:"
read name
age=$1
profession=$2
echo "name is: $name"
echo "age is: $1"
echo "profession is: $2"
if [ $name == sudha ]
then
    echo -e "$G give access $N"
else
    echo -e "$R reject $N"
fi