module "gcp-instance" {
  source = "./modules/gcp-instance"

  service_account_path        = var.service_account_path
  project                     = var.project
  region                      = var.region
  zone                        = var.zone
  prefix                      = var.prefix
  name                        = var.name
  owner                       = var.owner
  scheduler                   = var.scheduler
  machine_type                = var.machine_type
  machine_type2               = var.machine_type2
  disk_type                   = var.disk_type
  disk_size                   = var.disk_size
  image                       = var.image
  enable_monitoring           = var.enable_monitoring
}

