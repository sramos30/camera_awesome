#!/usr/bin/env bash

usage() {
    #if [ "$*" ]; then
    #    echo "$*"
    #    echo
    #fi
    echo "Usage: $(basename $0) branch-name [create]"
    echo "       $(basename $0) push [comments]"
    echo "                                           "
    exit 2
}

switchBranch() {
    BRANCH_NAME="$1"
    echo "switchBranch ${BRANCH_NAME}"
    git checkout ${BRANCH_NAME}
    git switch --discard-changes "${BRANCH_NAME}"
    echo ${BRANCH_NAME} > switched
}

createBranch() {
    BRANCH_NAME="$1"
    echo "createBranch ${BRANCH_NAME}"
    git branch ${BRANCH_NAME}
    git switch --discard-changes "${BRANCH_NAME}"
    echo ${BRANCH_NAME} > switched
}

pushBranch() {
    BRANCH_NAME="$1"
    COMMENTS="$2"
    echo "pushBranch ${BRANCH_NAME} ${COMMENTS}"
    # rm -f switched
    find . -type f -name "*.lock"  -exec rm -rf {} \;
    find . -type d -name node_modules -exec rm -rf {} \;
    git add --all
    git commit -m "${BRANCH_NAME} changes ${COMMENTS}"
    git push --set-upstream origin ${BRANCH_NAME}
}

BRANCH_NAME=""
ACTION=""

if [ -z "$1" ];
then
    usage
fi

if [ -f ./switched ];
then
    BRANCH_NAME=$(<./switched ) 2> /dev/null
fi

if [ "$1" == "push" ];
then
    ACTION=$1
else
    if [ "$1" != "${BRANCH_NAME}"] ];
    then
        BRANCH_NAME=$1
        if [ "$2" == "create" ];
        then
            ACTION="create"
        else
            ACTION="switch"
        fi
    fi
fi

if [ -z $BRANCH_NAME ];
then
    usage
fi

if [ "${ACTION}" == "switch" ];
then
    switchBranch "${BRANCH_NAME}"
else if [ "${ACTION}" == "push" ];
    then
        pushBranch "${BRANCH_NAME}" "$2"
    else if [ "${ACTION}" == "create" ];
        then
            createBranch "${BRANCH_NAME}"
        else
            usage
        fi
    fi
fi

