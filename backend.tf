terraform {
  backend "gcs" {
    bucket = "assessment-terraform-state-bucket"
    prefix = "terraform/state"     
  }
}
