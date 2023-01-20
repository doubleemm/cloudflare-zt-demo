output "server_ip" {
    description = "The public IPs of the Compute Instances"
    value = google_compute_instance.vm[*].network_interface.0.access_config.0.nat_ip
}

