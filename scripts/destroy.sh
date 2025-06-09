#!/bin/bash

set -e

# Check for AWS credentials
if [ -f ~/.aws/credentials ]; then
    echo "Using AWS credentials from ~/.aws/credentials"
    export AWS_PROFILE=${AWS_PROFILE:-default}
elif [ -f .env ]; then
    echo "Using AWS credentials from .env file"
    source .env
    export AWS_ACCESS_KEY_ID
    export AWS_SECRET_ACCESS_KEY
    export AWS_REGION
else
    echo "No AWS credentials found. Please configure ~/.aws/credentials or create a .env file"
    exit 1
fi

echo "Destroying Prodigy infrastructure..."

cd terraform

terraform destroy -auto-approve

echo "Infrastructure destroyed successfully!"