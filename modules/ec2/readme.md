# EC2 Module

## Overview

This Terraform module provisions an AWS EC2 instance with support for dynamic user data templating, flexible configuration, and environment-based tagging. It is designed to be reusable across multiple environments such as development, staging, and production.

---

## Features

* Launch EC2 instances with configurable instance types
* Dynamic AMI resolution (recommended via data sources)
* User data templating using `templatefile()`
* Environment-based tagging strategy
* Clean and reusable module interface

---

## Architecture

This module:

* Accepts infrastructure inputs (AMI, subnet, instance type)
* Renders user data scripts dynamically
* Provisions a single EC2 instance
* Outputs instance metadata for downstream usage

---

## Inputs

| Name          | Type   | Required | Default  | Description                                   |
| ------------- | ------ | -------- | -------- | --------------------------------------------- |
| name          | string | yes      | n/a      | Name of the EC2 instance                      |
| ami_id / ami  | string | yes*     | n/a      | AMI ID (optional if using dynamic AMI lookup) |
| instance_type | string | no       | t2.micro | EC2 instance type                             |
| subnet_id     | string | yes      | n/a      | Subnet ID where instance will be deployed     |
| app_name      | string | yes      | n/a      | Application name used in user data            |
| env           | string | yes      | n/a      | Environment name (dev, prod, etc.)            |
| aws_region    | string | yes      | n/a      | AWS region for deployment                     |

> *AMI can be dynamically resolved using `aws_ami` data source instead of passing `ami_id`.

---

## Outputs

| Name        | Description            |
| ----------- | ---------------------- |
| instance_id | ID of the EC2 instance |

---

## Usage Example

```hcl
module "ec2" {
  source        = "../../modules/ec2"
  name          = "dev-instance"
  ami_id       = var.ami_id
  instance_type = var.instance_type
  subnet_id     = module.vpc.subnet_ids[0]
  app_name      = "dev-app"
  env           = var.env
  aws_region    = var.aws_region
}
```

## User Data Template

File: `user_data.sh.tpl`

```bash
#!/bin/bash
echo "Starting ${app_name}" > /var/log/app.log
```

---

## Tagging Strategy

The module applies the following tags:

* Name → Instance identifier
* Environment → dev / prod
* ManagedBy → Terraform

Example:

```
Name = web-server-dev
Environment = dev
ManagedBy = Terraform
```

---

## Best Practices

* Avoid hardcoding AMIs; use `aws_ami` or SSM parameters
* Keep modules provider-agnostic (no provider blocks inside module)
* Use consistent naming conventions across modules
* Version modules using Git tags (e.g., v1.0.0)
* Validate inputs where necessary

---

## Versioning

Example usage with version:

```hcl
module "ec2" {
  source = "git::https://github.com/your-org/ec2-module.git?ref=v1.0.0"
}
```

---

## Requirements

* Terraform >= 1.3
* AWS Provider >= 5.x
* AWS account with EC2 permissions

---

## Notes

* Ensure the subnet belongs to the same region as the EC2 instance
* Security groups and key pairs should be added for production usage
* Consider using `user_data_base64` for improved compatibility

---

## Future Enhancements

* Add support for multiple instances (count / for_each)
* Integrate security groups module
* Add key pair support
* Add autoscaling group support
* Add IAM role attachment

---

## Author

Terraform Module - EC2 (Reusable Infrastructure Component)
