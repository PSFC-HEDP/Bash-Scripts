#!/bin/bash
#set -x 


# *************************************************
# Check to see if the user has passwordless access
# *************************************************

ssh -o PasswordAuthentication=no  -o BatchMode=yes chewie-local exit &>/dev/null
test $? == 0 && checkChewie=true || (checkChewie=false; echo "WARNING: YOU DON'T HAVE PASSWORDLESS ACCESS TO CHEWIE!")

ssh -o PasswordAuthentication=no  -o BatchMode=yes han-local exit &>/dev/null
test $? == 0 && checkHan=true || (checkHan=false; echo "WARNING: YOU DON'T HAVE PASSWORDLESS ACCESS TO HAN!")

ssh -o PasswordAuthentication=no  -o BatchMode=yes luke-local exit &>/dev/null
test $? == 0 && checkLuke=true || (checkLuke=false; echo "WARNING: YOU DON'T HAVE PASSWORDLESS ACCESS TO LUKE!")



# **********************************************
# Handle the users (note we're using ben users)
# **********************************************

# Get user list
allUsers=($(cat /etc/passwd | awk -F ':' '{print $1}'))
userIDs=($(cat /etc/passwd | awk -F ':' '{print $3}'))

# Filter out system users
users=()
for i in ${!userIDs[@]}
do
	if [ ${userIDs[$i]} -gt 999 ] && [ ${userIDs[$i]} -lt 2000 ]
	then
		users+=(${allUsers[$i]})
	fi
done

# Sort users
IFS=$'\n' users=($(sort <<< "${users[*]}")); unset IFS



# ***************************
# Run the top command on ben
# ***************************

# Get the top output
topOutput=$(top -bn1)

# Get the number of CPUs
nCPUs=$(nproc)


# Get the usage of each user
for i in ${!users[@]}
do

    temp=($(echo "$topOutput" | awk -v u=${users[$i]} \
        '$2 ~ u && $12 != "top" {count++} END {print count}'))
    if [ -z "$temp" ]
    then
        benProcCount[$i]=0
    else    
        benProcCount[$i]=$temp
    fi

    temp=($(echo "$topOutput" | awk -v u=${users[$i]} -v N=$nCPUs \
        '$2 ~ u && $12 != "top" {sum += $9} END {print sum/N}'))
    if [ -z "$temp" ]
    then
        benCpuUsage[$i]=0
    else    
        benCpuUsage[$i]=$temp
    fi
    
    benProcTotal=$(echo | awk -v a=$benProcTotal -v b=${benProcCount[$i]} '{print a+b}')
    benCpuTotal=$(echo | awk -v a=$benCpuTotal -v b=${benCpuUsage[$i]} '{print a+b}')
    
    procTotal=$(echo | awk -v a=$procTotal -v b=${benProcCount[$i]} '{print a+b}')
    cpuTotal=$(echo | awk -v a=$cpuTotal -v b=${benCpuUsage[$i]} '{print a+(b/4)}')
  
done



# ******************************
# Run the top command on chewie
# ******************************

if [ $checkChewie = true ] 
then
    
    # Get the top output
    topOutput=$(ssh chewie-local top -bn1)

    # Get the number of CPUs
    nCPUs=$(ssh chewie-local nproc)


    # Get the usage of each user
    for i in ${!users[@]}
    do

        temp=($(echo "$topOutput" | awk -v u=${users[$i]} \
            '$2 ~ u && $12 != "top" {count++} END {print count}'))
        if [ -z "$temp" ]
        then
            chewieProcCount[$i]=0
        else    
            chewieProcCount[$i]=$temp
        fi

        temp=($(echo "$topOutput" | awk -v u=${users[$i]} -v N=$nCPUs \
            '$2 ~ u && $12 != "top" {sum += $9} END {print sum/N}'))
        if [ -z "$temp" ]
        then
            chewieCpuUsage[$i]=0
        else    
            chewieCpuUsage[$i]=$temp
        fi
        
        chewieProcTotal=$(echo | awk -v a=$chewieProcTotal -v b=${chewieProcCount[$i]} '{print a+b}')
        chewieCpuTotal=$(echo | awk -v a=$chewieCpuTotal -v b=${chewieCpuUsage[$i]} '{print a+b}')

        procTotal=$(echo | awk -v a=$procTotal -v b=${chewieProcCount[$i]} '{print a+b}')
        cpuTotal=$(echo | awk -v a=$cpuTotal -v b=${chewieCpuUsage[$i]} '{print a+(b/4)}')
      
    done
fi



# ****************************
# Run the top command on luke
# ****************************

if [ $checkLuke = true ] 
then
    # Get the top output
    topOutput=$(ssh luke-local top -bn1)

    # Get the number of CPUs
    nCPUs=$(ssh luke-local nproc)


    # Get the usage of each user
    for i in ${!users[@]}
    do

        temp=($(echo "$topOutput" | awk -v u=${users[$i]} \
            '$2 ~ u && $12 != "top" {count++} END {print count}'))
        if [ -z "$temp" ]
        then
            lukeProcCount[$i]=0
        else    
            lukeProcCount[$i]=$temp
        fi

        temp=($(echo "$topOutput" | awk -v u=${users[$i]} -v N=$nCPUs \
            '$2 ~ u && $12 != "top" {sum += $9} END {print sum/N}'))
        if [ -z "$temp" ]
        then
            lukeCpuUsage[$i]=0
        else    
            lukeCpuUsage[$i]=$temp
        fi
        
        lukeProcTotal=$(echo | awk -v a=$lukeProcTotal -v b=${lukeProcCount[$i]} '{print a+b}')
        lukeCpuTotal=$(echo | awk -v a=$lukeCpuTotal -v b=${lukeCpuUsage[$i]} '{print a+b}')

        procTotal=$(echo | awk -v a=$procTotal -v b=${lukeProcCount[$i]} '{print a+b}')
        cpuTotal=$(echo | awk -v a=$cpuTotal -v b=${lukeCpuUsage[$i]} '{print a+(b/4)}')
      
    done
fi



# ***************************
# Run the top command on han
# ***************************

if [ $checkHan = true ] 
then
    # Get the top output
    topOutput=$(ssh han-local top -bn1)

    # Get the number of CPUs
    nCPUs=$(ssh han-local nproc)


    # Get the usage of each user
    for i in ${!users[@]}
    do

        temp=($(echo "$topOutput" | awk -v u=${users[$i]} \
            '$2 ~ u && $12 != "top" {count++} END {print count}'))
        if [ -z "$temp" ]
        then
            hanProcCount[$i]=0
        else    
            hanProcCount[$i]=$temp
        fi

        temp=($(echo "$topOutput" | awk -v u=${users[$i]} -v N=$nCPUs \
            '$2 ~ u && $12 != "top" {sum += $9} END {print sum/N}'))
        if [ -z "$temp" ]
        then
            hanCpuUsage[$i]=0
        else    
            hanCpuUsage[$i]=$temp
        fi
        
        hanProcTotal=$(echo | awk -v a=$hanProcTotal -v b=${hanProcCount[$i]} '{print a+b}')
        hanCpuTotal=$(echo | awk -v a=$hanCpuTotal -v b=${hanCpuUsage[$i]} '{print a+b}')

        procTotal=$(echo | awk -v a=$procTotal -v b=${hanProcCount[$i]} '{print a+b}')
        cpuTotal=$(echo | awk -v a=$cpuTotal -v b=${hanCpuUsage[$i]} '{print a+(b/4)}')
      
    done
fi


# Print stuff
clear
printf "\n%28s%16s%28s\n" " " "Usage Statistics" " "
printf "%12s %12s %12s %12s %12s\n" "User" "Ben CPUs" "Chewie CPUs" "Luke CPUs" "Han CPUs" 

for i in ${!users[@]}
do
	printf "%12s %6.1f (%3d) %6.1f (%3d) %6.1f (%3d) %6.1f (%3d) \n" ${users[$i]} \
        ${benCpuUsage[$i]} ${benProcCount[$i]} \
        ${chewieCpuUsage[$i]} ${chewieProcCount[$i]} \
        ${lukeCpuUsage[$i]} ${lukeProcCount[$i]} \
        ${hanCpuUsage[$i]} ${hanProcCount[$i]}
done

printf "%12s %6.1f (%3d) %6.1f (%3d) %6.1f (%3d) %6.1f (%3d) %6.1f (%3d)\n\n" "Totals:" \
        $benCpuTotal $benProcTotal \
        $chewieCpuTotal $chewieProcTotal \
        $lukeCpuTotal $lukeProcTotal \
        $hanCpuTotal $hanProcTotal \
        $cpuTotal $procTotal 



