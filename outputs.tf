output "server_ip" {
    description = "The public IPs of the Compute Instances"
    value = module.gcp-instance[*].server_ip
}

output "tunnel_token" {
  value = module.cloudflare.tunnel_token
}

output "tunnel_secret" {
  value = module.cloudflare.tunnel_secret
}

