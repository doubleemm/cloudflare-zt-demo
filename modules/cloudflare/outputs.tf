# Output the tunnel token and secret

output "tunnel_token" {
  value = cloudflare_argo_tunnel.srv-win01.tunnel_token
}

output "tunnel_secret" {
  value = random_id.tunnel_secret
}