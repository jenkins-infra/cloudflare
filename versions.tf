terraform {
  required_version = ">= 1.15, <1.16"
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
  }
}
