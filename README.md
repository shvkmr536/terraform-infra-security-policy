# Terraform Infrastructure Project

## Overview

This project demonstrates a modular Terraform architecture for provisioning AWS infrastructure across multiple environments. It leverages reusable modules to create a Virtual Private Cloud (VPC) and deploy EC2 instances with environment-specific configurations.

The design follows infrastructure-as-code (IaC) best practices including modularization, parameterization, and environment isolation.

---

## Project Structure

```
terraform-modules/
├── modules/
│   ├── vpc/        # VPC module
│   └── ec2/        # EC2 module
│
├── environments/
│   ├── dev/        # Development environment
│   └── prod/       # Production environment
│
└── README.md
```

---

## Architecture

This project provisions:

* A VPC with configurable CIDR block
* Public subnets across availability zones
* An EC2 instance deployed into the VPC
* Environment-specific configurations (dev/prod)

### Flow:

1. Root configuration calls VPC module
2. VPC module creates network resources
3. EC2 module consumes subnet outputs from VPC
4. EC2 instance is deployed with user data script

---

## Modules Used

### 1. VPC Module

* Creates VPC and subnets
* Outputs subnet IDs for downstream usage

### 2. EC2 Module

* Launches EC2 instance
* Uses `templatefile()` for dynamic user data
* Applies environment-based tagging

---

## Environment Configuration

Each environment has its own configuration and variables.

### Dev Environment

* Smaller instance (e.g., t2.micro)
* Lower-cost setup

### Prod Environment

* Larger instance (e.g., t3.medium)
* Production-ready configuration

---

## Prerequisites

* Terraform >= 1.3
* AWS CLI configured (`aws configure`)
* IAM permissions for:

  * EC2
  * VPC
  * Subnets

---

## Usage

### 1. Initialize Terraform

```bash
cd environments/dev
terraform init
```

---

### 2. Validate Configuration

```bash
terraform validate
```

---

### 3. Plan Infrastructure

```bash
terraform plan
```

---

### 4. Apply Changes

```bash
terraform apply
```

---

### 5. Destroy Infrastructure

```bash
terraform destroy
```

---

## Environment Switching

To deploy a different environment:

```bash
cd environments/prod
terraform init
terraform apply
```

Each environment maintains its own state and configuration.

---

## Variables Example (dev/terraform.tfvars)

```hcl
vpc_cidr = "10.0.0.0/16"

public_subnets = {
  "ap-south-1a" = "10.0.1.0/24"
  "ap-south-1b" = "10.0.2.0/24"
}

instance_type = "t2.micro"
env           = "dev"
aws_region    = "ap-south-1"
```

---

## Module Composition

This project demonstrates module composition:

```
VPC Module → outputs subnet_ids
EC2 Module → consumes subnet_ids
```

This creates an implicit dependency between modules, ensuring correct resource creation order.

---

## Best Practices Implemented

* Modular architecture (separation of concerns)
* Reusable modules with input/output contracts
* Environment-based configuration
* Dynamic user data templating
* Consistent tagging strategy
* Input validation in modules
* No hardcoded infrastructure values

---

## Versioning Strategy

Modules should be versioned using Git tags:

```bash
git tag v1.0.0
git push origin v1.0.0
```

Example usage:

```hcl
module "vpc" {
  source = "git::https://github.com/your-org/vpc-module.git?ref=v1.0.0"
}
```

---

## Security Considerations

* Avoid hardcoding sensitive values
* Use IAM roles instead of access keys
* Restrict security group rules
* Use remote state (S3 + DynamoDB) for team environments

---

## Future Improvements

* Add remote backend (S3 + DynamoDB)
* Implement Terraform workspaces
* Add CI/CD pipeline (GitHub Actions)
* Introduce security groups module
* Add autoscaling support
* Integrate monitoring (CloudWatch)

---

## Troubleshooting

### Common Issues

**1. Invalid AMI**

* Use dynamic AMI lookup (`aws_ami`)

**2. Provider Errors**

* Remove `.terraform` and reinitialize

**3. Variable Mismatch**

* Ensure module inputs match variable names exactly

---

## Key Takeaways

* Terraform modules enable reusable infrastructure
* Environment separation ensures safe deployments
* Module composition builds scalable architectures
* Proper naming and consistency prevent most errors

---

## Author

Terraform Infrastructure Project – Modular AWS Deployment
