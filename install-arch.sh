#!/bin/bash

source .colors

SEPARATOR="------------------------------------------"

if [ $(uname -n ) != "archiso" ]; then
	echo -e "${BLINK}This isn't an arch installation, exiting...$END"
	exit 1;
fi

echo -e "${GREEN}Arch installation $END"
echo -e $SEPARATOR

echo -e "
Devices available:
"
lsblk
echo -e $SEPARATOR
echo -e "$RED
The next step is to format drives. Make sure that you specify the correct one from the device list. $END
Format: /dev/sdX
"
