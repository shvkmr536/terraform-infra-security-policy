terraform {
  required_version = ">= 1.6.0"

  backend "s3" {
    bucket       = "hypha-demo-001"
    key          = "prod/ec2/state.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
