resource "cloudflare_r2_bucket" "westeurope_updates_jenkins_io" {
  account_id = local.account_id["jenkins-infra-team"]
  name       = "westeurope-updates-jenkins-io"
  location   = "WEUR"
}

# Keeping this main zone imported as data only so we don't risk destroying it (the sponsoring is attached to it)
data "cloudflare_zone" "cloudflare_jenkins_io" {
  account_id = local.account_id["jenkins-infra-team"]
  name       = "cloudflare.jenkins.io"
}

## West Europe
resource "cloudflare_record" "westeurope" {
  for_each = data.cloudflare_zone.cloudflare_jenkins_io.name_servers

  zone_id = data.cloudflare_zone.cloudflare_jenkins_io.id
  name    = "westeurope"
  value   = "${each.key}"
  type    = "NS"
  ttl     = 60
}

resource "cloudflare_zone" "westeurope_cloudflare_jenkins_io" {
  account_id = local.account_id["jenkins-infra-team"]
  zone       = "westeurope.cloudflare.jenkins.io"
  depends_on = [
    cloudflare_record.westeurope
  ]
}
