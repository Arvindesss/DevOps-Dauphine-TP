resource "google_project_service" "ressource_manager" {
    service = "cloudresourcemanager.googleapis.com"
}

resource "google_project_service" "ressource_usage" {
    for_each = toset(["serviceusage.googleapis.com"])
    service = "serviceusage.googleapis.com"
    depends_on = [ google_project_service.ressource_manager ]
}

resource "google_project_service" "artifact" {
    service = "artifactregistry.googleapis.com"
    depends_on = [ google_project_service.ressource_manager ]
}

resource "google_artifact_registry_repository" "demo-repo" {
  location      = "us-central1"
  repository_id = "demo-repository"
  description   = "Exemple de repo Docker"
  format        = "DOCKER"

  depends_on = [ google_project_service.artifact ]
}
resource "google_sql_database" "database" {
  name     = "wordpress"
  instance = "main-instance"
}

# See versions at https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance#database_version
resource "google_sql_database_instance" "instance" {
  name             = "my-database-instance"
  region           = "us-central1"
  database_version = "MYSQL_8_0"
  settings {
    tier = "db-f1-micro"
  }

  deletion_protection  = true
}

resource "google_sql_user" "wordpress" {
   name     = "wordpress"
   instance = "main-instance"
   password = "ilovedevops"
}

# ATTENTION : A changer: le nom doit être unique !
resource "google_storage_bucket" "default" {
     name          = "terraform-bucket-sitn-bis" 
     location      = "US"
     force_destroy = true
}

data "google_iam_policy" "noauth" {
   binding {
      role = "roles/run.invoker"
      members = [
         "allUsers",
      ]
   }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
   location    = "us-central1" # remplacer par le nom de votre ressource
   project     = "tpnote-449407" # remplacer par le nom de votre ressource
   service     = "wordpress-service" # remplacer par le nom de votre ressourcecs
   policy_data = data.google_iam_policy.noauth.policy_data
}

resource "google_cloud_run_service" "default" {
  name     = "wordpress-service" 
  location = "us-central1" 

  template {
    spec {
      containers {
        image = "us-central1-docker.pkg.dev/tpnote-449407/website-tools/wordpress-custom"
        ports {
          container_port = 80
        }
      }
    }
  }
  
}