#!/bin/bash
# Simple destroy helper: usage ./destroy.sh <env>
set -euo pipefail

if [ "$#" -ne 1 ]; then
	echo "Usage: $0 <environment>"
	exit 1
fi

ENV=$1
ENV_DIR="environments/$ENV"
TFVARS_FILE="${ENV}.tfvars"

if [ ! -d "$ENV_DIR" ]; then
	echo "Environment '$ENV_DIR' not found"
	exit 2
fi

if [ ! -f "$ENV_DIR/$TFVARS_FILE" ]; then
	echo "Missing tfvars file: $ENV_DIR/$TFVARS_FILE"
	exit 3
fi

cd "$ENV_DIR"

terraform init -input=false

terraform plan \
  -destroy \
  -var-file="$TFVARS_FILE" \
  -out=destroy.tfplan \
  -input=false

terraform apply -input=false destroy.tfplan