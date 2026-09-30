terraform {
  required_version = "1.15.2"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.16.0"
    }

    sops = {
      source  = "carlpett/sops"
      version = "1.3.0"
    }

    github = {
      source  = "integrations/github"
      version = "6.10.2"
    }
  }

  cloud {
    organization = "momeemt"
    workspaces {
      name = "config"
    }
  }
}

