locals {
  account_id = {
    jenkins-infra-team = "8d1838a43923148c5cee18ccc356a594"
  }

  regions = {
    westeurope  = "WEUR"
    eastamerica = "ENAM"
  }

  r2_token_expiration_date = "2025-09-10T00:00:00Z"

  r2_api_permissions = {
    for x in data.cloudflare_account_api_token_permission_groups_list.this.result :
    x.name => x.id
    if contains(["Workers R2 Storage Bucket Item Read", "Workers R2 Storage Bucket Item Write"], x.name)
  }

  r2_allowed_ips = {
    "trusted.jenkins.io" = [
      "104.209.128.236/32", # Outbound IP of the trusted virtual network NAT gateway
    ],
    # Trusted agents outbound IPs retrievable in https://github.com/jenkins-infra/azure-net/blob/7aa7fc5a8a39dd7bafee0e89c4fffe096692baa8/outputs.tf#L11-L13
    "trusted.sponsorship.jenkins.io" = [
      "172.177.128.34/32",
      "172.210.175.108/32",
      "172.210.170.228/32",
    ],
  }
}
