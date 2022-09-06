module "project" {
  source          = "./modules/project"
  project_id      = var.project_id
  folder_id       = var.folder_id
  org_fdqn        = var.org_fdqn
  org_id          = var.org_id
  project_name    = var.project_name
  billing_account = var.billing_account
}
