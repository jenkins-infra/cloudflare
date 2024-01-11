terraform {
  required_version = ">= 1.6, <1.7"
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
}
