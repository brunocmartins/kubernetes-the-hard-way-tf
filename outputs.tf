output "compute_reserved_ip" {
  value       = var.step_3 ? google_compute_address.kubernetes[0].address : null
  description = "The reserved compute IP"
}
