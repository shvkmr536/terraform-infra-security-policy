#!/bin/bash
set -euo pipefail

ENV=$1
ENV_DIR="environments/$ENV"
TFVARS_FILE="$ENV.tfvars"

cd "$ENV_DIR"

echo "🔧 Initializing Terraform..."
terraform init -input=false

echo "📦 Creating execution plan..."
terraform plan \
  -var-file="$TFVARS_FILE" \
  -out=tfplan.binary \
  -input=false

echo "🔍 Converting plan to JSON..."
terraform show -json tfplan.binary > tfplan.json

echo "🛡️ Running policy checks (OPA)..."

OPA_RESULT=$(opa eval \
  --format raw \
  --input tfplan.json \
  --data ../../policies \
  "data.terraform.deny")

echo "OPA Result: $OPA_RESULT"

if [ "$OPA_RESULT" = "[]" ]; then
  echo "----------------------------------------"
  echo "✅ Policy check passed: no violations found"
  echo "----------------------------------------"
else
  echo "----------------------------------------"
  echo "❌ Policy check failed: violations detected"
  echo "$OPA_RESULT"
  echo "----------------------------------------"
  exit 1
fi

echo "🚀 Applying infrastructure..."
terraform apply -input=false tfplan.binary

echo "✅ Infrastructure deployment completed successfully!"