resource "google_folder" "main" {
  display_name = var.folder_id
  parent       = var.org_fdqn
}

resource "google_project" "main" {
  name       = var.project_name
  project_id = var.project_id
  org_id     = var.org_id
  billing_account = var.billing_account
}

