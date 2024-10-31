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
