# ----- CLOUDFLARE PROVIDER ----- #

// If using a Cloudflare-Provider make sure to store API-Token and Account-ID in "secret.tfvars" 
//
// cloudflare_api_token        = <API-Token>
// cloudflare_account_id       = <Account-ID>
//
// Apply the settings with [terraform apply -var-file="secret.tfvars"]

cloudflare_tunnel01_name    = "zt-demo-tunnel-win01"
cloudflare_tunnel02_name    = "zt-demo-tunnel-win02"
cloudflare_zone             = "mike-demo.uk"
cloudflare_email            = "mmajunke@cloudflare.com"

# ---- GCP PROVIDER ---- #
service_account_path        = "/Users/mmajunke/.config/gcloud/application_default_credentials.json"
project                     = "globalse-198312"
region                      = "europe-west3"
zone                        = "europe-west3-b"
prefix                      = "mmajunke"
name                        = "zt-demo"
owner                       = "mmajunke"
scheduler                   = "emea"
machine_type                = "e2-standard-2"
machine_type2               = "e2-medium"
disk_type                   = "pd-balanced"
disk_size                   = 50
#image                       = "windows-server-2016-dc-v20230712"
image                       = "windows-server-2022-dc-v20221109"
enable_monitoring           = false
