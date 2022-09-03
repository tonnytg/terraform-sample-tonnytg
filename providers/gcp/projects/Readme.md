# Create GCP Projects

This files help to create project with Terraform support.

### How to use?

1. Create Main Project
2. Create Service Account on Main project
3. Create Key for this Service Account and save on local folder
4. Create your product project using terraform and save state on bucket


### Why do this?

Best practices of Terraform don't recommend you save file of Terraform State
on Git, this is because you can't control lock files and your team can break it.
We can forget commit or another problems of Git.

Best Practioce recommend you save tfsate files of Terraform on Bucket.
Then, this files to help you in this loop of inseption.


### Creating Main Project

To create main project you needed run commands with gcloud. I put some Scripts
in folder `helpers` where you can run to build.

After create project, create Service Account and save key on same folder
terraform files using this account.


### Create product Project

Now you can build your project

terraform plan && terraform appy
