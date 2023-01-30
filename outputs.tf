output "server_ip" {
    description = "The public IPs of the Compute Instances"
    value = module.gcp-instance[*].server_ip
}

output "tunnel_token01" {
  value = module.cloudflare.tunnel_token01
}

output "tunnel_token02" {
  value = module.cloudflare.tunnel_token02
}

output "tunnel_secret" {
  value = module.cloudflare.tunnel_secret
}

