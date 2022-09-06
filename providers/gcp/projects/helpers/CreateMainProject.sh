#!/bin/bash
# This ShellScript creat first project to storage all informations about other
# projects.
# This script run for the first time only.

# Variables
# Change project name what you want, but don't use space
export MAIN_NAME="main-automation"

# Only change values if you know what you do
# Admin
export ORG_ID=$1
export B_ACCOUNT=$2
export FOLDER_ID=$3
# Project
export PROJECT_ID=${MAIN_NAME}-${FOLDER_ID}
export PROJECT_NAME="Main"
#ServiceAccount
export SA_NAME="terraform-sa"
export SA_DESCRIPTION="Account for Terraform of ${PROJECT_ID}"
export SA_DISPLAY_NAME="terraform-sa"

# Set Permissions
setRolePermissions() {
	# Set Permission
	gcloud projects add-iam-policy-binding ${PROJECT_ID} \
		--member serviceAccount:${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com \
		--role roles/owner

	gcloud organizations add-iam-policy-binding ${ORG_ID} \
		--member serviceAccount:${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com \
		--role roles/billing.user

	gcloud organizations add-iam-policy-binding ${ORG_ID} \
		--member serviceAccount:${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com \
		--role roles/resourcemanager.projectCreator
}

# Functions
createServiceAccount() {
	# Create account
	gcloud iam service-accounts create ${SA_NAME} \
		--description   "${SA_DESCRIPTION}" \
		--display-name  ${SA_DISPLAY_NAME} \
		--project       ${PROJECT_ID} \
		
	# Create and Export key
	export KEY_NAME="terraform-sa-key"
	gcloud iam service-accounts keys create ${KEY_NAME}.json \
		--iam-account ${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com \
		--project ${PROJECT_ID}
}

createProject() {
	gcloud projects create ${PROJECT_ID} --name=${PROJECT_NAME} \
		--set-as-default --folder=${FOLDER_ID}

	if [ $? -eq 0 ]; then
		echo "Project ${PROJECT_ID} created"
	else
		echo "Error: Project ${PROJECT_ID} not created, maybe already exist"
	fi
}

enableAPIs() {
	gcloud services enable cloudbilling.googleapis.com \
		--project ${PROJECT_ID}
	gcloud services enable cloudresourcemanager.googleapis.com \
		--project ${PROJECT_ID}
}

setBillingAccount() {
	gcloud beta billing projects link ${PROJECT_ID} \
		--billing-account ${B_ACCOUNT}

	if [ $? -eq 0 ]; then
		echo "Project ${PROJECT_ID} linked to Billing Account ${B_ACCOUNT}"
	else
		echo "Error: Project ${PROJECT_ID} not linked!"
	fi
}

createStorage() {
	# Create bucket to storage terraform state
	gcloud alpha storage buckets create gs://${PROJECT_ID}-bucket \
		--project ${PROJECT_ID}

	if [ $? -eq 0 ]; then
		echo "Storage ${PROJECT_ID}-bucket created"
	else
		echo "Error: Storage ${PROJECT_ID}-bucket not created, maybe already exist"
	fi
}

# Main of Script
if [ $# -eq 3 ];
then
	createProject
	enableAPIs
	setBillingAccount
	createStorage
	createServiceAccount
	setRolePermissions
	exit 0
fi

echo "Error: Too many arguments, need only 2 arguments"
echo "Usage: $0 <ORG_ID> <BILLING_ACCOUNT> <FOLDER_ID>"
exit 1
