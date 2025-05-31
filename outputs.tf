output "zones_name_servers" {
  value = {
    for k, zone in cloudflare_zone.updates_jenkins_io : k => zone.name_servers
  }
}

resource "local_file" "jenkins_infra_data_report" {
  content = jsonencode({
    for k, zone in cloudflare_zone.updates_jenkins_io : "${k}.cloudflare.jenkins.io" => { "zone_nameservers" = zone.name_servers }
  })
  filename = "${path.module}/jenkins-infra-data-reports/cloudflare.json"
}

output "r2_buckets" {
  sensitive = true
  value = jsonencode({
    for id, bucket in cloudflare_r2_bucket.updates_jenkins_io : id => {
      "access_key_id"     = cloudflare_account_token.r2_updates_jenkins_io[id].id,
      "secret_access_key" = sha256(cloudflare_account_token.r2_updates_jenkins_io[id].value),
      "r2_endpoint_url"   = "https://${local.account_id["jenkins-infra-team"]}.r2.cloudflarestorage.com"
    }
  })
}
