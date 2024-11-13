variable "project_name" {
  description = "The name of the GCP project"
  type        = string
  default     = "quick-assesment"
}

variable "region" {
  description = "The region for the VPC"
  type        = string
  default     = "asia-east1"
}

variable "subnets" {
  description = "A list of subnets to create"
  type = map(object({
    name          = string
    region        = string
    ip_cidr_range = string
    pods_ip_range = string
    services_ip_range = string
  }))
  default = {
    "subnet_100" = {
      name          = "subnet-100"
      region        = "asia-east1"
      ip_cidr_range = "10.10.0.0/24"
      pods_ip_range   = "10.10.1.0/24"  # Pods range
      services_ip_range = "10.10.2.0/24"  # Services range
    },
    "subnet_200" = {
      name          = "subnet-200"
      region        = "europe-west1"
      ip_cidr_range = "10.11.0.0/24"
      pods_ip_range  = "10.11.1.0/24"  # Pods range
      services_ip_range = "10.11.2.0/24"  # Services range
    }
  }
}
variable "zone" {
  description = "The zone where the GKE cluster control plane will be created"
  type        = string
  default     = "asia-east1-a"
}

variable "node_zones" {
  description = "List of zones for the GKE node pool"
  type        = list(string)
  default     = ["asia-east1-a", "asia-east1-b", "asia-east1-c"]
}

variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
  default     = "private-gke-cluster"
}
