terraform {
  backend "s3" {
    bucket                      = "homelab-cluster-kubernetes-management"
    force_path_style            = true
    key                         = "terraform.tfstate"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
  }
}
