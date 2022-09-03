#!/bin/bash

# Create Service Account for Terraform
# Segregate Scope to Project

export SA_NAME="terraform-sa"
export SA_DESCRIPTION="Account for Terraform"
export SA_DISPLAY_NAME="terraform-sa"
export PROJECT_ID="$1"

gcloud iam service-accounts create ${SA_NAME} \
    --description   "${SA_DESCRIPTION}" \
    --display-name  ${SA_DISPLAY_NAME} \
    --project       ${PROJECT_ID} \


