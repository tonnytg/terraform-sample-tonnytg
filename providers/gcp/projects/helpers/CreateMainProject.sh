#!/bin/bash
# This ShellScript creat first project to storage all informations about other
# projects.
# This script run for the first time only.

# Variables
export PROJECT_ID="main-terraform"-${1}
export PROJECT_NAME="Main"
export SA_NAME="terraform-sa"
export SA_DESCRIPTION="Account for Terraform"
export SA_DISPLAY_NAME="terraform-sa"
export B_ACCOUNT=$2

# Functions
createServiceAccount() {
	# Create account
	gcloud iam service-accounts create ${SA_NAME} \
		--description   "${SA_DESCRIPTION}" \
		--display-name  ${SA_DISPLAY_NAME} \
		--project       ${PROJECT_ID} \
		
	# Set Permission
	gcloud projects add-iam-policy-binding ${PROJECT_ID} \
		--member serviceAccount:${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com \
		--role roles/owner
		
	# Create and Export key
	export KEY_NAME="terraform-sa-key"
	gcloud iam service-accounts keys create ${KEY_NAME}.json \
		--iam-account ${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com \
		--project ${PROJECT_ID}
}

createProject() {
	gcloud projects create ${PROJECT_ID} --name=${PROJECT_NAME} \
		--set-as-default --folder=$1

	if [ $? -eq 0 ]; then
		echo "Project ${PROJECT_ID} created"
	else
		echo "Project ${PROJECT_ID} not created"
		exit 1
	fi
}

setBillingAccount() {
	gcloud beta billing projects link ${PROJECT_ID} \
		--billing-account ${B_ACCOUNT}
}

createStorage() {
	# Create bucket to storage terraform state
	gcloud alpha storage buckets create gs://${PROJECT_ID}-bucket \
		--project ${PROJECT_ID}
}

# Main of Script
if [ $# -eq 2 ];
then
	createProject $1 $2
	setBillingAccount $1
	createStorage $1
	createServiceAccount $1
	exit 0
fi

echo "Error: Too many arguments, need only 2 arguments"
echo "Usage: $0 <folder_id> <billing_account>"
exit 1
