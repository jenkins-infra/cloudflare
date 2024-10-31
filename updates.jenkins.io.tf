resource "cloudflare_zone" "updates_jenkins_io" {
  for_each = local.regions

  account_id = local.account_id["jenkins-infra-team"]
  zone       = "${each.key}.cloudflare.jenkins.io"
}

resource "cloudflare_r2_bucket" "updates_jenkins_io" {
  for_each = local.regions

  account_id = local.account_id["jenkins-infra-team"]
  name       = "${each.key}-updates-jenkins-io"
  location   = each.value
}

output "zones_name_servers" {
  value = {
    for k, zone in cloudflare_zone.updates_jenkins_io : k => zone.name_servers
  }
}

import {
  id = "account/${local.account_id.jenkins-infra-team}/772143"
  to = cloudflare_logpush_job.account_audit_logs
}
resource "cloudflare_logpush_job" "account_audit_logs" {
  enabled          = true
  account_id       = local.account_id.jenkins-infra-team
  name             = "account-audit-logs-to-datadog"
  destination_conf = "datadog://http-intake.logs.datadoghq.com/api/v2/logs?header_DD-API-KEY=${var.cloudflare_datadog_api_key}&ddsource=cloudflare&service=updates.jenkins.io&host=cloudflare.jenkins.io"
  dataset          = "audit_logs"

  output_options {
    cve20214428      = true
    sample_rate      = 0
    timestamp_format = "rfc3339"
    field_names = [
      "ActionResult",
      "ActionType",
      "ActorEmail",
      "ActorID",
      "ActorIP",
      "ActorType",
      "ID",
      "Interface",
      "Metadata",
      "NewValue",
      "OldValue",
      "OwnerID",
      "ResourceID",
      "ResourceType",
      "When"
    ]
  }
}
