terraform {
  required_version = ">= 1.6.0"

  backend "s3" {
    bucket       = "hypha-demo-002"
    key          = "prod/state.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
