#!/bin/bash
source .bash_helpers

SEPARATOR="------------------------------------------"

confirmation "$RED asdasd $END $GREEN asdasdas $END"

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
