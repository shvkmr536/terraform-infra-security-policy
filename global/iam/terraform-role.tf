terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.34.0"
    }
  }
}

terraform {
  required_version = ">= 1.6.0"

  backend "s3" {
    bucket       = "hypha-demo-002"
    key          = "dev/state.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}

// Minimal IAM role and policy for GitHub Actions OIDC-based assume role
resource "aws_iam_role" "github_actions" {
	name               = "github-actions-oidc-role"
	assume_role_policy = data.aws_iam_policy_document.github_oidc.json
}

data "aws_iam_policy_document" "github_oidc" {
	statement {
		actions = ["sts:AssumeRoleWithWebIdentity"]
		principals {
			type        = "Federated"
			identifiers = ["arn:aws:iam::123456789012:oidc-provider/token.actions.githubusercontent.com"]
		}
		condition {
			test     = "StringEquals"
			variable = "token.actions.githubusercontent.com:sub"
			values   = ["repo:shvkmr536/terraform-github-action:ref:refs/heads/main"]
		}
	}
}

resource "aws_iam_role_policy" "github_actions_policy" {
	name   = "github-actions-basic-policy"
	role   = aws_iam_role.github_actions.id
	policy = data.aws_iam_policy_document.github_actions_policy.json
}

data "aws_iam_policy_document" "github_actions_policy" {
	statement {
		actions = [
			"s3:GetObject",
			"s3:PutObject",
			"s3:ListBucket",
			"dynamodb:PutItem",
			"dynamodb:GetItem",
			"dynamodb:Query",
			"dynamodb:UpdateItem",
			"sts:AssumeRole"
		]
		resources = ["*"]
	}
}

