provider "google" {
  credentials = file(var.service_account_path)
  project     = var.project
  region      = var.region

}

resource "time_static" "timestamp" {}

resource "google_compute_instance" "vm" {
  count = 2
  name = "${var.prefix}-${time_static.timestamp.unix}-${count.index}"
  machine_type = "${count.index == 0 ? var.machine_type : var.machine_type2}"
  zone = var.zone
  labels = {
    "owner" =  var.owner
    "scheduler" = var.scheduler
    "service" = var.name
  }
  boot_disk {
    auto_delete = true
    initialize_params {
      size = var.disk_size
      image = var.image
    }  
  }
  network_interface {
    network = "default"
    access_config {
      // Ephemeral IP
    }
  }
metadata = {
    sysprep-specialize-script-ps1 = file("${path.module}/sysprep-specialize-script-ps1.ps1")
    windows-startup-script-ps1 = file("${path.module}/windows-startup-script-ps1.ps1")
  }




}
