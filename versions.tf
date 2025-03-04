terraform {
  required_version = ">= 1.11, <1.12"
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
}
