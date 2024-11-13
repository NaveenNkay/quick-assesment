
resource "google_compute_network" "assessment-vpc" {
  name                    = "assessment-vpc"
  auto_create_subnetworks  = false  # Setting this to false means we will create custom subnets
  routing_mode             = "GLOBAL"  # Regional routing mode for better control
}

resource "google_compute_subnetwork" "subnets" {
  for_each = { for idx, subnet in var.subnets : subnet.name => subnet }

  name          = each.value.name
  region        = each.value.region
  network       = google_compute_network.assessment-vpc.id
  ip_cidr_range = each.value.ip_cidr_range
  secondary_ip_range {
    range_name    = "pods-secondary-range"
    ip_cidr_range = each.value.pods_ip_range
  }
  secondary_ip_range {
    range_name    = "services-secondary-range"
    ip_cidr_range = each.value.services_ip_range
  }
}
resource "google_compute_router" "router" {
  name    = "router"
  region  = var.region
  network = google_compute_network.assessment-vpc.id
}

resource "google_compute_address" "nat-address" {
  name         = "nat-address"
  address_type = "EXTERNAL"
  region  = var.region
  network_tier = "PREMIUM"
}

resource "google_compute_router_nat" "nat" {
  name   = "nat"
  router = google_compute_router.router.name
  region = var.region

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  nat_ip_allocate_option             = "MANUAL_ONLY"

  subnetwork {
    name                    = google_compute_subnetwork.subnets[keys(google_compute_subnetwork.subnets)[0]].name
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  nat_ips = [google_compute_address.nat-address.self_link]
}

resource "google_container_cluster" "private_gke" {
  name     = var.cluster_name
  initial_node_count = 1
  location  = "asia-east1"
  network    = google_compute_network.assessment-vpc.id
  subnetwork = google_compute_subnetwork.subnets[keys(google_compute_subnetwork.subnets)[0]].name
  remove_default_node_pool = true
  default_max_pods_per_node = 10
  
  private_cluster_config {
    enable_private_endpoint = true
    enable_private_nodes    = true
	master_ipv4_cidr_block = "10.10.3.0/28"
  }
  ip_allocation_policy {
    cluster_secondary_range_name  = google_compute_subnetwork.subnets[keys(google_compute_subnetwork.subnets)[0]].secondary_ip_range[0].range_name
    services_secondary_range_name = google_compute_subnetwork.subnets[keys(google_compute_subnetwork.subnets)[1]].secondary_ip_range[1].range_name
  }
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "0.0.0.0/0"
      display_name = "asia-east1"
  }
  }
  node_config {
    machine_type = "e2-small"
    disk_size_gb = 20
  }
  deletion_protection = false
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "my-node-pool"
  location   = "asia-east1"
  cluster    = google_container_cluster.private_gke.name
  node_count = 1
  autoscaling {
    min_node_count = 1  # Minimum number of nodes
    max_node_count = 2  # Maximum number of nodes
  }
  node_config {
    preemptible  = true
    disk_size_gb = 20
    machine_type = "e2-medium"
  }
}
