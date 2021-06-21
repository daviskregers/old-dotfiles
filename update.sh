#!/bin/bash
DOTFILES="$(pwd)"
ARCH=$(uname)
CONFIGURATION_PATH=scripts/$ARCH

source .bash_helpers
source .variables

echo -e "${GREEN}Using $ARCH configuration$END"
echo $SEPARATOR

for configuration in $CONFIGURATION_PATH/*
do
	echo -e "${RED}\nApplying $configuration$END"
	echo $SEPARATOR
	source $configuration || exit 1
done
