# resource "cloudflare_zone" "updates_jenkins_io" {
#   for_each = local.regions

#   account_id = local.account_id["jenkins-infra-team"]
#   zone       = "${each.key}.cloudflare.jenkins.io"
# }

# resource "cloudflare_r2_bucket" "updates_jenkins_io" {
#   for_each = local.regions

#   account_id = local.account_id["jenkins-infra-team"]
#   name       = "${each.key}-updates-jenkins-io"
#   location   = "${each.value}"
# }

# output "zones_name_servers" {
#   value = {
#     for k, zone in cloudflare_zone.updates_jenkins_io : k => zone.name_servers
#   }
# }
