# --- Cloudflare Provider --- #

variable "cloudflare_api_token" {
  type = string
  sensitive = true
}

variable "cloudflare_account_id" {
    type = string
    sensitive = true
}

variable "cloudflare_zone" {
  type = string  
}

variable "cloudflare_zone_id" {
  type = string
  sensitive = true  
}

variable "cloudflare_tunnel01_name" {
    type = string
}

variable "cloudflare_tunnel02_name" {
    type = string
}

variable "cloudflare_email" {
    type = string
}

# --- Google Provider ---
variable "service_account_path" {
  type = string
  default = "/Users/mmajunke/.config/gcloud/application_default_credentials.json"
}

variable "project" {
  type = string
  description = "Personal project id. The project indicates the default GCP project all of your resources will be created in."
}

variable "region" {
  type = string
  default = "europe-west1"
}

variable "zone" {
  type = string
  default = "europe-west1-b"
}

# --- General ---
variable "prefix" {
  type = string
  description = "(Optional) Resources name prefix"
}

# --- Instance Configuration ---
variable "name" {
  type = string
}

variable "owner" {
    type = string
}

variable "scheduler" {
  type = string
}

variable "machine_type" {
  type = string
}

variable "machine_type2" {
  type = string
}

variable "disk_type" {
  type = string
  description = "Storage space is much less expensive for a standard Persistent Disk. An SSD Persistent Disk is better for random IOPS or streaming throughput with low latency."
}
variable "disk_size" {
  type = number
  description = "Disk size in GB - Persistent disk performance is tied to the size of the persistent disk volume. You are charged for the actual amount of provisioned disk space."
}

 variable "image" {
   type = string
 }

 variable "enable_monitoring" {
   type = bool
 }
