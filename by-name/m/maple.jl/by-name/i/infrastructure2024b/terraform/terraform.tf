terraform {
  required_version = "1.8.3"

  backend "s3" {
    bucket = "terraform"
    key    = "terraform.tfstate"
    endpoints = {
      s3 = "https://minio.momee.mt/"
    }
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    use_path_style              = true
  }
}
