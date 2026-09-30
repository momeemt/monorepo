locals {
  blog_pages = {
    project_name      = "blog-momee-mt-2026"
    production_branch = "develop"
    domain            = "blog.momee.mt"
  }
}

resource "cloudflare_pages_project" "blog" {
  account_id        = local.cloudflare.account_id
  name              = local.blog_pages.project_name
  production_branch = local.blog_pages.production_branch
}

resource "cloudflare_pages_domain" "blog" {
  account_id   = local.cloudflare.account_id
  project_name = cloudflare_pages_project.blog.name
  name         = local.blog_pages.domain
}

resource "cloudflare_dns_record" "blog_dns_record" {
  zone_id = local.cloudflare.zone_id
  name    = "blog"
  type    = "CNAME"
  content = cloudflare_pages_project.blog.subdomain
  ttl     = 1
  proxied = true
  comment = "Cloudflare Pages project for blog.momee.mt 2026"
}
