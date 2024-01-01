#!/bin/bash
num1=$1
num2=$2

    if [$num1==0 || $num2==0 ]
    then 
        echo "not possible to proceed"
        exit
    else
        echo "proceed for further process"
    fi

