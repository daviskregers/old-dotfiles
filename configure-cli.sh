#!/bin/bash

# TODO: add alias, git sync

source .bash_helpers
source configuration/.variables
source configuration/.functions

ARCH=$(uname)
CONFIGURATION_PATH=$DOTFILES/scripts/Cli

echo -e "${GREEN}Using $ARCH configuration$END"

echo $SEPARATOR

for configuration in $CONFIGURATION_PATH/*
do
	echo -e "${RED}\nApplying $configuration$END"
	echo $SEPARATOR
	source $configuration
done

