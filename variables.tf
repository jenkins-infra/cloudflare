variable "cloudflare_api_token" {
  description = "Cloudflare API token to allow Terraform manipulating resources"
  sensitive   = true
}

variable "cloudflare_datadog_api_key" {
  description = "Datadog API key used by Cloudflare to push logs, metrics and traces"
  default     = ""
  sensitive   = true
}
