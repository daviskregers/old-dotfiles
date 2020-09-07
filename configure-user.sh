#!/bin/bash

source .bash_helpers
ARCH=$(uname)
CONFIGURATION_PATH=scripts/$ARCH

echo -e "${GREEN}Using $ARCH configuration$END"

echo $SEPARATOR

for configuration in $CONFIGURATION_PATH/*
do
	echo -e "${RED}\nApplying $configuration$END"
	echo $SEPARATOR
	source $configuration
done

