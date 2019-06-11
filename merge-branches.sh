#! /bin/bash

ARGUMENT_MESSAGE="Arguments missing \"merge-branches [from] [to]\". For example \"merge-branches work master\"."

if [[ $# -eq 0 ]]; then
    echo $ARGUMENT_MESSAGE
fi

if [[ $# -eq 0 ]]; then
    echo $ARGUMENT_MESSAGE
    exit 1;
fi

git checkout $1
git pull
git checkout $2
git pull
git merge --no-log --no-ff --no-commit $1
git checkout $2 .asoundrc.asoundconf monitor-layout.sh
