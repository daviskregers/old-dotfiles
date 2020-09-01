#!/bin/bash

SEPARATOR="------------------------------------------"

if [ $(uname -n ) != "archiso" ]; then
	echo "This isn't an arch installation, exiting...";
	exit 1;
fi

echo "Arch installation"
echo $SEPARATOR

echo "
Devices available: 
"
lsblk
echo $SEPARATOR
echo "
The next step is to format drives. Make sure that you specify the correct one from the device list.
Format: /dev/sdX
"
