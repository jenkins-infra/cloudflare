resource "cloudflare_r2_bucket" "westeurope_updates_jenkins_io" {
  account_id = local.account_id["jenkins-infra-team"]
  name       = "westeurope-updates-jenkins-io"
  location   = "WEUR"
}
