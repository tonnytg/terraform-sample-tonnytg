terraform {

  backend "gcs" {
   bucket  = "seed-bucket"
   prefix  = "terraform/state"
   credentials = "/path/to/seed-credentials.json"
 }

  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.34.0"
    }
  }
}

provider "google" {
  # Configuration options
  # https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/getting_started
 
  credentials = "/path/to/seed-credentials.json"
  project     = "seed-project"
  region      = "us-central1"

}
