output "zones_name_servers" {
  value = {
    for k, zone in cloudflare_zone.updates_jenkins_io : k => zone.name_servers
  }
}
