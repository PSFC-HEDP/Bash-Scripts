#!/bin/bash
#set -x 

if [ $# -eq 2 ]; then
    user=$2
else
    user=$(whoami)
fi

if [ $# -gt 0 ]; then
    program=$1
else
    echo "usage: killAll.sh programName [user] (Example: ./killAll.sh mcnp620)"
    echo ""
    exit 0
fi

# *************************************************
# Check to see if the user has passwordless access
# *************************************************

ssh -o PasswordAuthentication=no  -o BatchMode=yes chewie-local exit &>/dev/null
test $? == 0 && checkChewie=true || (checkChewie=false; echo "WARNING: YOU DON'T HAVE PASSWORDLESS ACCESS TO CHEWIE!")

ssh -o PasswordAuthentication=no  -o BatchMode=yes han-local exit &>/dev/null
test $? == 0 && checkHan=true || (checkHan=false; echo "WARNING: YOU DON'T HAVE PASSWORDLESS ACCESS TO HAN!")

ssh -o PasswordAuthentication=no  -o BatchMode=yes luke-local exit &>/dev/null
test $? == 0 && checkLuke=true || (checkLuke=false; echo "WARNING: YOU DON'T HAVE PASSWORDLESS ACCESS TO LUKE!")



# ********************
# Get the ben procIDs
# ********************

procIDs=($(top -bn1 | awk -v u=$user -v p=$program \
    '$2 ~ u && $12 ~ p && $12 != "top" {print $1}'))

procNames=($(top -bn1 | awk -v u=$user -v p=$program \
    '$2 ~ u && $12 ~ p && $12 != "top" {print $12}'))
    
for i in ${!procIDs[@]}; do
    printf "Killing %s on ben ..." ${procNames[$i]}
    kill -9 ${procIDs[$i]} &> /dev/null
    printf "Done!\n" 
done    
    


# ***********************
# Get the chewie procIDs
# ***********************

if [ $checkChewie = true ]; then
    
    procIDs=($(ssh chewie-local top -bn1 | awk -v u=$user -v p=$program \
        '$2 ~ u && $12 ~ p && $12 != "top" {print $1}'))

    procNames=($(ssh chewie-local top -bn1 | awk -v u=$user -v p=$program \
        '$2 ~ u && $12 ~ p && $12 != "top" {print $12}'))
        
    for i in ${!procIDs[@]}; do
        printf "Killing %s on chewie ..." ${procNames[$i]}
        ssh chewie-local kill -9 ${procIDs[$i]} &> /dev/null
        printf "Done!\n" 
    done
    
fi



# *********************
# Get the luke procIDs
# *********************

if [ $checkLuke = true ]; then
    
    procIDs=($(ssh luke-local top -bn1 | awk -v u=$user -v p=$program \
        '$2 ~ u && $12 ~ p && $12 != "top" {print $1}'))

    procNames=($(ssh luke-local top -bn1 | awk -v u=$user -v p=$program \
        '$2 ~ u && $12 ~ p && $12 != "top" {print $12}'))
        
    for i in ${!procIDs[@]}; do
        printf "Killing %s on luke ..." ${procNames[$i]}
        ssh luke-local kill -9 ${procIDs[$i]} &> /dev/null
        printf "Done!\n" 
    done
    
fi



# ********************
# Get the han procIDs
# ********************

if [ $checkHan = true ]; then
    
    procIDs=($(ssh han-local top -bn1 | awk -v u=$user -v p=$program \
        '$2 ~ u && $12 ~ p && $12 != "top" {print $1}'))

    procNames=($(ssh han-local top -bn1 | awk -v u=$user -v p=$program \
        '$2 ~ u && $12 ~ p && $12 != "top" {print $12}'))
        
    for i in ${!procIDs[@]}; do
        printf "Killing %s on han ..." ${procNames[$i]}
        ssh han-local kill -9 ${procIDs[$i]} &> /dev/null
        printf "Done!\n" 
    done
    
fi


