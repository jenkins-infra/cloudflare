locals {
  default_tags = {
    scope      = "terraform-managed"
    repository = "jenkins-infra/azure"
  }

  account_id = {
    jenkins-infra-team = "8d1838a43923148c5cee18ccc356a594"
  }
}