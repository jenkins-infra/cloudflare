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

import {
  id = "zone/${cloudflare_zone.updates_jenkins_io["eastamerica"].id}/771340"
  to = cloudflare_logpush_job.zones_access_logs["eastamerica"]
}
resource "cloudflare_logpush_job" "zones_access_logs" {
  for_each = toset(["eastamerica"])

  enabled          = true
  zone_id          = cloudflare_zone.updates_jenkins_io[each.key].id
  name             = "${each.key}-access-logs-to-datadog"
  destination_conf = "datadog://http-intake.logs.datadoghq.com/api/v2/logs?header_DD-API-KEY=${var.cloudflare_datadog_api_key}&ddsource=cloudflare-r2&service=updates.jenkins.io&host=${each.key}.cloudflare.jenkins.io"
  dataset          = "http_requests"

  output_options {
    cve20214428      = true
    sample_rate      = 0
    timestamp_format = "rfc3339"
    field_names = [
      "RayID",
      "CacheCacheStatus",
      "CacheReserveUsed",
      "CacheResponseBytes",
      "CacheResponseStatus",
      "CacheTieredFill",
      "ClientASN",
      "ClientCountry",
      "ClientDeviceType",
      "ClientIP",
      "ClientIPClass",
      "ClientRegionCode",
      "ClientRequestBytes",
      "ClientRequestHost",
      "ClientRequestMethod",
      "ClientRequestPath",
      "ClientRequestProtocol",
      "ClientRequestReferer",
      "ClientRequestScheme",
      "ClientRequestSource",
      "ClientRequestURI",
      "ClientRequestUserAgent",
      "ClientSrcPort",
      "ClientTCPRTTMs",
      "ClientXRequestedWith",
      "ContentScanObjResults",
      "ContentScanObjTypes",
      "Cookies",
      "EdgeEndTimestamp",
      "EdgePathingOp",
      "EdgePathingSrc",
      "EdgePathingStatus",
      "EdgeRequestHost",
      "EdgeResponseBodyBytes",
      "EdgeResponseBytes",
      "EdgeResponseCompressionRatio",
      "EdgeResponseContentType",
      "EdgeResponseStatus",
      "EdgeStartTimestamp",
      "EdgeTimeToFirstByteMs",
      "OriginDNSResponseTimeMs",
      "OriginIP",
      "OriginRequestHeaderSendDurationMs",
      "OriginResponseBytes",
      "OriginResponseDurationMs",
      "OriginResponseHeaderReceiveDurationMs",
      "OriginResponseHTTPExpires",
      "OriginResponseHTTPLastModified",
      "OriginResponseStatus",
      "OriginResponseTime",
      "OriginTCPHandshakeDurationMs",
      "OriginTLSHandshakeDurationMs",
      "RequestHeaders",
      "ResponseHeaders",
      "SecurityAction",
      "SecurityActions",
      "SecurityRuleDescription",
      "SecurityRuleID",
      "SecurityRuleIDs",
      "SecuritySources",
      "WAFAttackScore",
      "WAFFlags",
      "WAFMatchedVar",
      "WAFRCEAttackScore",
      "WAFSQLiAttackScore",
      "WAFXSSAttackScore",
      "WorkerCPUTime",
      "WorkerWallTimeUs",
    ]
  }
}
