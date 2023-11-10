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
resource "random_password" "tunnel_secret" {
  length  = 64
}

### Create CF Tunnel
resource "cloudflare_argo_tunnel" "zt-demo-srv-win01" {
  account_id = var.cloudflare_account_id
  name       = var.cloudflare_tunnel01_name
  secret     = base64sha256(random_password.tunnel_secret.result)
}

resource "cloudflare_argo_tunnel" "zt-demo-srv-win02" {
  account_id = var.cloudflare_account_id
  name       = var.cloudflare_tunnel02_name
  secret     = base64sha256(random_password.tunnel_secret.result)
}

### Create DNS for the tunnel
resource "cloudflare_record" "zt-demo-rdp01-dns" {
  zone_id = var.cloudflare_zone_id
  name    = "rdpwin01"
  value   = cloudflare_argo_tunnel.zt-demo-srv-win01.cname
  type    = "CNAME"
  proxied = true
}

resource "cloudflare_record" "zt-demo-rdp02-dns" {
  zone_id = var.cloudflare_zone_id
  name    = "rdpwin02"
  value   = cloudflare_argo_tunnel.zt-demo-srv-win02.cname
  type    = "CNAME"
  proxied = true
}

### CREATE ACCESS APPLICATION

resource "cloudflare_access_application" "zt-demo-rdp-app" {
  zone_id          = var.cloudflare_zone_id
  name             = "Access protection for rdp.${var.cloudflare_zone}"
  domain           = "rdpwin01.${var.cloudflare_zone}"
  session_duration = "1h"
}

### CREATE ACCESS-POLICY FOR RDP ACCESS

resource "cloudflare_access_policy" "zt-demo-rdp-policy" {
  application_id = cloudflare_access_application.zt-demo-rdp-app.id
  zone_id        = var.cloudflare_zone_id
  name           = "Example Policy for rdp.${var.cloudflare_zone}"
  precedence     = "1"
  decision       = "allow"
 
  include {
    email = ["${var.cloudflare_email}"]
  }
}

resource "cloudflare_tunnel_config" "zt-demo-srv-win01-config" {
  account_id = var.cloudflare_account_id
  tunnel_id  = cloudflare_argo_tunnel.zt-demo-srv-win01.id

  config {
    warp_routing {
      enabled = true
    }
    
    ingress_rule {
      hostname = "${cloudflare_record.zt-demo-rdp01-dns.name}.${var.cloudflare_zone}"
      service  = "rdp://localhost:3389"
    }

    ingress_rule {
      service  = "http_status:404"
    }
  }
}

resource "cloudflare_tunnel_config" "zt-demo-srv-win02-config" {
  account_id = var.cloudflare_account_id
  tunnel_id  = cloudflare_argo_tunnel.zt-demo-srv-win02.id

  config {
    warp_routing {
      enabled = true
    }
    
    ingress_rule {
      hostname = "${cloudflare_record.zt-demo-rdp02-dns.name}.${var.cloudflare_zone}"
      service  = "rdp://localhost:3389"
    }

    ingress_rule {
      service  = "http_status:404"
    }
  }
}

### GATEWAY POLICIES

resource "cloudflare_teams_rule" "zt-demo-pol1" {
  account_id  = var.cloudflare_account_id
  name        = "zt-demo-pol1"
  description = "desc"
  precedence  = 99
  action      = "block"
  filters     = ["http"]
  traffic     = "any(http.request.uri.content_category[*] in {67 133 17 85 87 102 157 135 138 180 162 32 115 169 177 124 128 161 170 165})"
  rule_settings {
    block_page_enabled = true
    block_page_reason  = "access not permitted"
  }
}
