output "subnet_names" {
  value = [for s in google_compute_subnetwork.subnets : s.name]
}