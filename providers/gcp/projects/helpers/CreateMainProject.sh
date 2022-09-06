#!/bin/bash
# This ShellScript creat first project to storage all informations about other
# projects.
# This script run for the first time only.

# Variables
export ORG_ID=$1
export PROJECT_ID="main-terraform"-${3}
export PROJECT_NAME="Main"
export SA_NAME="terraform-sa"
export SA_DESCRIPTION="Account for Terraform"
export SA_DISPLAY_NAME="terraform-sa"
export B_ACCOUNT=$2

# Set Permissions
setRolePermissions() {
	# Set Permission
	gcloud projects add-iam-policy-binding ${PROJECT_ID} \
		--member serviceAccount:${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com \
		--role roles/owner

	gcloud organizations add-iam-policy-binding ${ORG_ID} \
		--member serviceAccount:${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com \
		--role roles/billing.admin

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
		--set-as-default --folder=$1

	if [ $? -eq 0 ]; then
		echo "Project ${PROJECT_ID} created"
	else
		echo "Error: Project ${PROJECT_ID} not created, maybe already exist"
	fi
}

enableAPIs() {
	gcloud services enable cloudbilling.googleapis.com \
		--project 697654160307
	gcloud services enable cloudresourcemanager.googleapis.com \
		--project 697654160307
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
	createProject $1 $2
	enableAPIs
	setBillingAccount $1
	createStorage $1
	createServiceAccount $1
	setRolePermissions $1
	exit 0
fi

echo "Error: Too many arguments, need only 2 arguments"
echo "Usage: $0 <ORG_ID> <BILLING_ACCOUNT> <FOLDER_ID>"
exit 1
