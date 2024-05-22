#!/bin/bash
# set -x

# Quick script to create a user on the cluster


# Create the user on all of the machines
## Usage is person's name, username, password
## Example: 'Timothy Johnson', tmarkj, rangefilter
sudo useradd --shell /bin/bash --comment "$1" --home /home/$2 --create-home $2
echo -e "$3\n$3" | (sudo passwd "$2")

ssh -t chewie-local "sudo useradd --shell /bin/bash --comment \"$1\" --home /home/$2 --create-home $2"
ssh -t chewie-local "echo -e \"$3\n$3\" | (sudo passwd \"$2\")"

ssh -t luke-local "sudo useradd --shell /bin/bash --comment \"$1\" --home /home/$2 --create-home $2"
ssh -t luke-local "echo -e \"$3\n$3\" | (sudo passwd \"$2\")"

ssh -t han-local "sudo useradd --shell /bin/bash --comment \"$1\" --home /home/$2 --create-home $2"
ssh -t han-local "echo -e \"$3\n$3\" | (sudo passwd \"$2\")"

