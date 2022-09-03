module "project" {
  source = "./modules/project"
  name = var.product_name
  environment = var.environment
  region = var.region
}
