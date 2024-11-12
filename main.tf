
resource "google_compute_network" "assessment_vpc" {
  name                    = "assessment_vpc"
  auto_create_subnetworks  = false  # Setting this to false means we will create custom subnets
  routing_mode             = "GLOBAL"  # Regional routing mode for better control
}

resource "google_compute_subnetwork" "subnets" {
  for_each = { for idx, subnet in var.subnets : subnet.name => subnet }

  name          = each.value.name
  region        = each.value.region
  network       = google_compute_network.assessment_vpc.id
  ip_cidr_range = each.value.ip_cidr_range
}
