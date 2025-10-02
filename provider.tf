terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version =  "~> 7.0.0"
    }
  }
}
provider "google" {
  project = var.project_id
  region  = var.region_id
  zone    = var.zone_id
}