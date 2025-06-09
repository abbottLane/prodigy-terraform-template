#!/bin/bash

set -e

PROJECT_NAME=${1:-prodigy-app}
SSH_KEY_PATH=${2:-~/.ssh/id_rsa.pub}

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

if [ ! -f "$SSH_KEY_PATH" ]; then
    echo "SSH public key not found at $SSH_KEY_PATH"
    echo "Please generate SSH keys or provide the correct path"
    exit 1
fi

SSH_PUBLIC_KEY=$(cat "$SSH_KEY_PATH")

echo "Deploying Prodigy infrastructure..."

cd terraform

terraform init

terraform apply -var="project_name=$PROJECT_NAME" \
                -var="ssh_public_key=$SSH_PUBLIC_KEY" \
                -auto-approve

echo "Infrastructure deployed successfully!"

INSTANCE_IP=$(terraform output -raw instance_public_ip)
S3_BUCKET=$(terraform output -raw s3_bucket_name)

echo "Instance IP: $INSTANCE_IP"
echo "S3 Bucket: $S3_BUCKET"

echo "Waiting for instance to be ready..."
sleep 60

echo "Copying application files to instance..."
scp -o StrictHostKeyChecking=no -r ../app ../config ../Dockerfile ../requirements.txt ../docker-compose.yml ec2-user@$INSTANCE_IP:~/prodigy-app/

echo "Building and starting application..."
ssh -o StrictHostKeyChecking=no ec2-user@$INSTANCE_IP << 'EOF'
cd ~/prodigy-app
sudo docker-compose down || true
sudo docker-compose build
sudo docker-compose up -d
EOF

echo "Deployment complete!"
echo "Prodigy is available at: http://$INSTANCE_IP:8080"