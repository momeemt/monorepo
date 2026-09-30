provider "sops" {}

data "sops_file" "secrets" {
  source_file = "../secrets/secrets.enc.yml"
}

locals {
  secrets = yamldecode(data.sops_file.secrets.raw)

  cloudflare = {
    api_token  = local.secrets.cloudflare.api_token
    zone_id    = local.secrets.cloudflare.zone_id
    account_id = local.secrets.cloudflare.account_id
  }

  github = {
    token          = local.secrets.github.token
    attic_endpoint = local.secrets.github.attic_endpoint
    attic_cache    = local.secrets.github.attic_cache
    attic_token    = local.secrets.github.attic_token
  }
}
