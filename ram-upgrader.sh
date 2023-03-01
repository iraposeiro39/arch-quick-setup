#!/bin/bash
#
# lol
#
clear
echo Starting. Please wait...
sleep 2
clear
echo "###################################
###### RAM UPGRADER Ver.2.3 #######
###################################"
echo " "
echo "Welcome to the future of Speed!"
echo " "
sleep 1
echo "With this script, I was able to expand my ram up to 32GB!"
echo " -Abibi, 32"
sleep 3
echo " "
echo "My pc is so fast, that light can't catch up to it, so the screen stays black!"
echo " -Karen, 54"
sleep 4
echo " "
echo "And these are just some of the reviews that we recieved!"
echo " "
echo " "
echo "======| What do you want to do? |======"
echo " "
echo "1> Increase RAM by 4GB"
echo "2> Increase RAM by 8GB"
echo "3> Increase RAM by 16GB"
echo "4> Increase RAM by 32GB"
while true
    do
        read -p ": " NUM
        case $NUM in
            [1]*) echo " "
                   echo "OK!"
                   echo ""
                   echo " "
                   break;;
            [Nn]*) echo " "
                   break;;
        esac
done