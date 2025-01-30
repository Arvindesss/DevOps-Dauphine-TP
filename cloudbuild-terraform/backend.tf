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
    region  = "us-central1" 
}

provider "kubernetes" {
   host                   = data.google_container_cluster.my_cluster.endpoint
   token                  = data.google_client_config.default.access_token
   cluster_ca_certificate = base64decode(data.google_container_cluster.my_cluster.master_auth.0.cluster_ca_certificate)
}

# Obtenez la configuration du client GCP
data "google_client_config" "default" {}

# Obtenez les détails de votre cluster GKE
data "google_container_cluster" "my_cluster" {
  name     = "wordpress-gke"
  location = "us-central1"
}