#!/bin/bash
yum update -y
yum install -y docker git

systemctl start docker
systemctl enable docker
usermod -a -G docker ec2-user

curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose

export S3_BUCKET=${S3_BUCKET}
export AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}
echo "export S3_BUCKET=${S3_BUCKET}" >> /home/ec2-user/.bashrc
echo "export AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}" >> /home/ec2-user/.bashrc

mkdir -p /home/ec2-user/prodigy-app
cd /home/ec2-user/prodigy-app

cat > docker-compose.yml << 'EOF'
version: '3.8'
services:
  prodigy:
    build: .
    ports:
      - "8080:8080"
    environment:
      - S3_BUCKET=${S3_BUCKET}
      - AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}
    restart: unless-stopped
EOF

chown -R ec2-user:ec2-user /home/ec2-user/prodigy-app