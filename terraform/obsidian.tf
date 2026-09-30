locals {
  obsidian_pages = {
    project_name      = "obsidian-momee-mt"
    production_branch = "develop"
    domain            = "obsidian.momee.mt"
  }
}

resource "cloudflare_pages_project" "obsidian" {
  account_id        = local.cloudflare.account_id
  name              = local.obsidian_pages.project_name
  production_branch = local.obsidian_pages.production_branch
}

resource "cloudflare_pages_domain" "obsidian" {
  account_id   = local.cloudflare.account_id
  project_name = cloudflare_pages_project.obsidian.name
  name         = local.obsidian_pages.domain
}

resource "cloudflare_dns_record" "obsidian_dns_record" {
  zone_id = local.cloudflare.zone_id
  name    = "obsidian"
  type    = "CNAME"
  content = cloudflare_pages_project.obsidian.subdomain
  ttl     = 1
  proxied = true
  comment = "Cloudflare Pages project for Obsidian Quartz"
}
