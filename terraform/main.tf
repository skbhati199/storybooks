terraform {
  backend "gcs" {
    bucket = "devops-app-336906-terraform"
    prefix = "/state/learningspacepro"
  }
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
  
}