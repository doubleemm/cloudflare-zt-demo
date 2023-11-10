# Output the tunnel token and secret

output "tunnel_token01" {
  value = cloudflare_argo_tunnel.zt-demo-srv-win01.tunnel_token
}

output "tunnel_token02" {
  value = cloudflare_argo_tunnel.zt-demo-srv-win02.tunnel_token
}

output "tunnel_secret" {
  value = random_password.tunnel_secret.result
  sensitive = true
}
