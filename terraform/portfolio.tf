locals {
  portfolio_pages = {
    project_name      = "momee-mt"
    production_branch = "develop"
    domain            = "momee.mt"
    www_domain        = "www.momee.mt"
  }
}

resource "cloudflare_pages_project" "portfolio" {
  account_id        = local.cloudflare.account_id
  name              = local.portfolio_pages.project_name
  production_branch = local.portfolio_pages.production_branch
}

resource "cloudflare_pages_domain" "portfolio" {
  account_id   = local.cloudflare.account_id
  project_name = cloudflare_pages_project.portfolio.name
  name         = local.portfolio_pages.domain
}

resource "cloudflare_pages_domain" "portfolio_www" {
  account_id   = local.cloudflare.account_id
  project_name = cloudflare_pages_project.portfolio.name
  name         = local.portfolio_pages.www_domain
}
