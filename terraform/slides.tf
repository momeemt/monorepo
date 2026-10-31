locals {
  slides_pages = {
    project_name      = "slides-momee-mt"
    production_branch = "develop"
    domain            = "slides.momee.mt"
  }
}

resource "cloudflare_pages_project" "slides" {
  account_id        = local.cloudflare.account_id
  name              = local.slides_pages.project_name
  production_branch = local.slides_pages.production_branch
}

resource "cloudflare_pages_domain" "slides" {
  account_id   = local.cloudflare.account_id
  project_name = cloudflare_pages_project.slides.name
  name         = local.slides_pages.domain
}

resource "cloudflare_dns_record" "slides_dns_record" {
  zone_id = local.cloudflare.zone_id
  name    = "slides"
  type    = "CNAME"
  content = cloudflare_pages_project.slides.subdomain
  ttl     = 1
  proxied = true
  comment = "Cloudflare Pages project for Typst slides"
}
