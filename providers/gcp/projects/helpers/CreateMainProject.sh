#!/bin/bash
# This ShellScript creat first project to storage all informations about other
# projects.
# This script is for the first time only.

PROJECT_ID="main-project"
PROJECT_NAME="Main"

createProject() {
    gcloud projects create ${PROJECT_ID}-${1} --name=${PROJECT_NAME} \
        --set-as-default --folder=$1

    if [ $? -eq 0 ]; then
        echo "Project ${PROJECT_ID}-${1} created"
    else
        echo "Project ${PROJECT_ID}-${1} not created"
        exit 1
    fi
}

if [ $# -eq 1 ];
then
    createProject $1
    exit 0
fi

echo "Error: Too many arguments"
exit 1
