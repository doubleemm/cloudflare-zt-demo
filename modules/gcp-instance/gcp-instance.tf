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

metadata = count.index == 0 ? {
    sysprep-specialize-script-ps1 = file("${path.module}/sysprep-specialize-script-ps1.ps1")
    windows-startup-script-ps1 = templatefile("${path.module}/windows-startup-script-ps1.ps1",{
      tunnel_token  = var.cf_tunnel_token01
    })
  } : {
    sysprep-specialize-script-ps1 = file("${path.module}/sysprep-specialize-script-ps1.ps1")
    windows-startup-script-ps1 = templatefile("${path.module}/windows-startup-script-ps1.ps1",{
      tunnel_token  = var.cf_tunnel_token02
    })
  }
}

// The local-exec provisioner will reset the windows password, since this is not supported by GCP-provider
// Make shure to have GCP gcloud cli installed and authenticated!!!
// Passwords will be written to local file password.gitignore.txt

resource "null_resource" "reset_password" {
  depends_on = [google_compute_instance.vm]
  provisioner "local-exec" {
    command = "sleep 300; gcloud compute reset-windows-password $VM1 --zone $ZONE > password.gitignore.txt; gcloud compute reset-windows-password $VM2 --zone $ZONE >> password.gitignore.txt"
    environment = {
      VM1 = google_compute_instance.vm[0].name
      VM2 = google_compute_instance.vm[1].name
      ZONE = google_compute_instance.vm[0].zone
    }
    interpreter = ["bash", "-c"]
  }
}