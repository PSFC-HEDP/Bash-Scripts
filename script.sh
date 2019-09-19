#!/bin/bash


commandStart="mpirun -H ben-local,chewie-local -np "
commandEnd="mcnp6.mpi "

for var in "$@"
do
    echo "$var"
    if ($var == "tasks"); then
#        continue
        commandStart=$commandStart$var" "
    else
	commandEnd=$commandEnd$var" "
    fi
done

command=$commandStart$commandEnd
echo "$command"
