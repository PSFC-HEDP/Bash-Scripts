#!/bin/bash
set -x

# Quick script to set up SSH-keys on all the machines


# Change password on all the machines
passwd
ssh -t chewie-local passwd
ssh -t luke-local passwd
ssh -t han-local passwd


# Set up key on ben
ssh-keygen -q -t rsa -N '' <<< ""$'\n'"y" 2>&1 >/dev/null
ssh-copy-id chewie-local
ssh-copy-id luke-local
ssh-copy-id han-local


# Set up key on chewie
ssh -t chewie-local "ssh-keygen -q -t rsa -N '' <<< \"\"$'\n'\"y\" 2>&1 >/dev/null"
ssh -t chewie-local "ssh-copy-id ben-local"
ssh -t chewie-local "ssh-copy-id luke-local"
ssh -t chewie-local "ssh-copy-id han-local"


# Set up key on luke
ssh -t luke-local "ssh-keygen -q -t rsa -N '' <<< \"\"$'\n'\"y\" 2>&1 >/dev/null"
ssh -t luke-local "ssh-copy-id ben-local"
ssh -t luke-local "ssh-copy-id chewie-local"
ssh -t luke-local "ssh-copy-id han-local"


# Set up key on han
ssh -t han-local "ssh-keygen -q -t rsa -N '' <<< \"\"$'\n'\"y\" 2>&1 >/dev/null"
ssh -t han-local "ssh-copy-id ben-local"
ssh -t han-local "ssh-copy-id chewie-local"
ssh -t han-local "ssh-copy-id luke-local"
