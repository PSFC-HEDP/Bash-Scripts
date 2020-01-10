#!/bin/bash

# Quick cluster user setup script

# Change your password just incase you have a temp one
passwd

# Generate an ssh key
ssh-keygen -t rsa

# Copy the key to the local machines
ssh-copy-id luke-local
ssh-copy-id chewie-local
ssh-copy-id ben-local
