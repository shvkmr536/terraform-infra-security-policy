# VPC Module

## Overview

This Terraform module provisions a Virtual Private Cloud (VPC) with configurable CIDR block and public subnets across multiple availability zones. It is designed to be reusable, flexible, and environment-agnostic.

The module follows Terraform best practices for modular infrastructure design, enabling consistent network provisioning across development, staging, and production environments.

---

## Features

* Create a VPC with custom CIDR block
* Provision public subnets across availability zones
* Dynamic subnet creation using `for_each`
* Input validation for CIDR blocks
* Outputs for seamless module composition
* Tagging support for resource identification

---

## Architecture

This module provisions:

* 1 VPC
* Multiple public subnets (based on input map)

### Flow:

1. Create VPC using provided CIDR block
2. Iterate over subnet map to create subnets
3. Assign subnets to specified availability zones
4. Output VPC and subnet IDs

---

## Inputs

| Name           | Type        | Required | Description                 |
| -------------- | ----------- | -------- | --------------------------- |
| name           | string      | yes      | Name of the VPC             |
| cidr_block     | string      | yes      | CIDR block for the VPC      |
| public_subnets | map(string) | yes      | Mapping of AZ → subnet CIDR |

### Example Input

```hcl
cidr_block = "10.0.0.0/16"

public_subnets = {
  "ap-south-1a" = "10.0.1.0/24"
  "ap-south-1b" = "10.0.2.0/24"
}
```

---

## Outputs

| Name       | Description               |
| ---------- | ------------------------- |
| vpc_id     | ID of the created VPC     |
| subnet_ids | List of public subnet IDs |

---

## Usage Example

```hcl
module "vpc" {
  source = "../../modules/vpc"

  vpc_cidr       = var.vpc_cidr
  public_subnets = var.public_subnets
  name           = "dev-vpc"
}
```

---

## Module Composition

This module is designed to integrate with other modules such as EC2:

```hcl
subnet_id = module.vpc.subnet_ids[0]
```

This enables downstream resources to be deployed inside the created VPC.

---

## Validation

The module validates CIDR block format:

```hcl
validation {
  condition     = can(cidrhost(var.cidr_block, 0))
  error_message = "Invalid CIDR block"
}
```

---

## Tagging Strategy

Resources are tagged using the VPC name:

* VPC → Name = `<vpc-name>`
* Subnets → Name = `<vpc-name>-public-<az>`

Example:

```
dev-vpc-public-ap-south-1a
```

---

## Best Practices

* Avoid hardcoding CIDR blocks; pass via variables
* Use consistent naming conventions across modules
* Keep modules provider-agnostic
* Use maps for scalable subnet definitions
* Validate inputs to prevent runtime errors

---

## Versioning

Use Git tags to version the module:

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

## Requirements

* Terraform >= 1.3
* AWS Provider >= 5.x

---

## Limitations

* Only public subnets are created
* No internet gateway or route tables included
* No private subnet support (can be added later)

---

## Future Enhancements

* Add private subnets
* Add NAT Gateway support
* Add Internet Gateway and route tables
* Add VPC flow logs
* Add IPv6 support

---

## Author

Terraform Module – VPC (Reusable Network Component)
