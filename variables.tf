variable "project_name" {
  description = "The name of the GCP project"
  type        = string
  default     = "quick-assesment"
}

variable "region" {
  description = "The region for the VPC"
  type        = string
  default     = "asia-east1"  # You can change this default or pass it via the command line
}

variable "subnets" {
  description = "A list of subnets to create"
  type = map(object({
    name          = string
    region        = string
    ip_cidr_range = string
  }))
  default = {
    "subnet_100" = {
      name          = "subnet-100"
      region        = "asia-east1"
      ip_cidr_range = "10.0.1.0/24"
    },
    "subnet_200" = {
      name          = "subnet-200"
      region        = "europe-west1"
      ip_cidr_range = "10.0.2.0/24"
    }
  }
}