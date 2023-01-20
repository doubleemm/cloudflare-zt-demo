terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

# Generate a random secret for the tunnel
resource "random_id" "tunnel_secret" {
  byte_length  = 32
}

resource "cloudflare_argo_tunnel" "srv-win01" {
  account_id = var.cloudflare_account_id
  name       = var.cloudflare_tunnel01_name
  secret     = random_id.tunnel_secret.b64_std
}


