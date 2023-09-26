# West Europe
resource "cloudflare_zone" "westeurope_cloudflare_jenkins_io" {
  account_id = local.account_id["jenkins-infra-team"]
  zone       = "westeurope.cloudflare.jenkins.io"
}

resource "cloudflare_r2_bucket" "westeurope_updates_jenkins_io" {
  account_id = local.account_id["jenkins-infra-team"]
  name       = "westeurope-updates-jenkins-io"
  location   = "WEUR"
}

output "westeurope_cloudflare_jenkins_io_ns_records" {
  value = cloudflare_zone.westeurope_cloudflare_jenkins_io.name_servers
}
