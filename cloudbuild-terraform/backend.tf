terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.10"
    }
  }

  backend "gcs" {
    bucket = "terraform-bucket-sitn"
  }

  required_version = ">= 1.0"
}


provider "google" {
    project = "tpnote-449407"
}