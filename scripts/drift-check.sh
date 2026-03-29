#!/bin/bash
set -euo pipefail

ENV=$1
ENV_DIR="environments/$ENV"
TFVARS_FILE="$ENV.tfvars"

cd "$ENV_DIR"

echo "🔧 Initializing Terraform..."
terraform init -input=false

echo "🔍 Checking for drift..."

# Disable exit-on-error temporarily
set +e

terraform plan \
  -detailed-exitcode \
  -var-file="$TFVARS_FILE" \
  -out=drift.tfplan \
  -input=false

EXIT_CODE=$?

PLAN_OUTPUT=$(terraform show -no-color drift.tfplan)

if echo "$PLAN_OUTPUT" | grep -q "Plan: [1-9][0-9]* to add, 0 to change, 0 to destroy"; then
  echo "----------------------------------------"
  echo "ℹ️ First-time creation detected (not drift)"
  echo "----------------------------------------"

elif echo "$PLAN_OUTPUT" | grep -q "to change"; then
  echo "----------------------------------------"
  echo "⚠️ Drift detected! Existing resources changed"
  echo "----------------------------------------"

elif echo "$PLAN_OUTPUT" | grep -q "No changes"; then
  echo "----------------------------------------"
  echo "✅ No drift detected"
  echo "----------------------------------------"

else
  echo "⚠️ Changes detected (review manually)"
fi