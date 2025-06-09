# Prodigy Hosted Template

A template for deploying Prodigy annotation projects to AWS EC2 with S3 storage and secure license key management.

## Features

- Dockerized Prodigy application
- AWS EC2 deployment with Terraform
- S3 integration for data storage
- Secure Prodigy license management via AWS Secrets Manager
- Automated deployment scripts
- Configurable annotation projects

## Prerequisites

- **Prodigy License**: Valid Prodigy license key from Explosion AI
- **AWS credentials** configured (see AWS Configuration below)
- **Terraform** installed
- **SSH key pair** for EC2 access (auto-generated if missing)
- **AWS Secrets Manager** setup with Prodigy license key

## Quick Start

1. **Setup Prodigy License in AWS Secrets Manager:**
   ```bash
   # Create secret with your Prodigy license key
   aws secretsmanager create-secret \
     --name "prodigy/key" \
     --description "Prodigy annotation tool license key" \
     --secret-string '{"prodigy-license-key":"YOUR-LICENSE-KEY"}'
   ```

2. **Clone and configure:**
   ```bash
   git clone <this-repo>
   cd prodigy-hosted-template
   ```

3. **Deploy infrastructure:**
   ```bash
   ./scripts/deploy.sh [project-name] [path-to-ssh-public-key]
   ```
   
   **Note**: SSH keys will be auto-generated if not found at `~/.ssh/id_rsa.pub`

4. **Access Prodigy:**
   - The script will output the instance IP
   - Access at `http://<instance-ip>:8080`

## Project Structure

```
├── app/                    # Prodigy application code
├── config/                 # Prodigy configuration files
├── terraform/              # Infrastructure as code
├── scripts/                # Deployment scripts
├── Dockerfile              # Container configuration
├── docker-compose.yml      # Local development
└── requirements.txt        # Python dependencies
```

## Configuration

### Prodigy Configuration
Edit `config/prodigy.json` to customize:
- Database settings
- UI preferences
- Batch sizes
- Custom themes

### AWS Configuration

**Credentials Priority Order:**
The deployment scripts check for AWS credentials in this order:
1. `~/.aws/credentials` (preferred method)
2. `.env` file in the project root

**Option 1: AWS CLI Configuration (Recommended)**
```bash
aws configure
# or manually create ~/.aws/credentials with your access keys
```

**Option 2: Environment File**
```bash
cp .env.example .env
# Edit .env with your AWS credentials
```

**Infrastructure Settings:**
Modify `terraform/variables.tf` for:
- Instance types
- Regions
- Security groups

## Custom Projects

To add custom annotation projects:

1. Add your recipes to `app/`
2. Update `requirements.txt` with additional dependencies
3. Modify `config/prodigy.json` as needed
4. Redeploy with `./scripts/deploy.sh`

## Local Development

```bash
docker-compose up --build
```

Access at `http://localhost:8080`

## Teardown

```bash
./scripts/destroy.sh
```

## Security Notes

- **Prodigy License Security**: License key is securely stored in AWS Secrets Manager and retrieved during container build
- **Network Security**: Default security group allows access from anywhere (0.0.0.0/0)
- **Access Control**: Modify `ssh_cidr_blocks` in `terraform/variables.tf` to restrict access
- **IAM Permissions**: EC2 instance has minimal IAM permissions for S3 and Secrets Manager access
- **Production Considerations**: Consider using AWS IAM roles and VPC for production deployments

### Required AWS Permissions

The deployment requires these AWS permissions:
- `secretsmanager:GetSecretValue` for Prodigy license retrieval
- `s3:*` for the created S3 bucket
- `ec2:*`, `iam:*`, `vpc:*` for infrastructure management

## Troubleshooting

### Common Issues

1. **"No matching distribution found for prodigy"**
   - Ensure your Prodigy license key is correctly stored in AWS Secrets Manager
   - Verify the secret name is exactly `prodigy/key`
   - Check IAM permissions for Secrets Manager access

2. **SSH connection issues**
   - Verify your SSH key pair is correctly generated/configured
   - Check security group allows SSH access (port 22)

3. **Prodigy not accessible**
   - Check container logs: `sudo docker logs prodigy-app-prodigy-1`
   - Verify security group allows port 8080
   - Ensure Prodigy is configured to listen on 0.0.0.0

## Costs

Running costs depend on:
- EC2 instance type (default: t3.medium ~$30/month)
- S3 storage usage (~$0.02/GB/month)
- Data transfer (~$0.09/GB)
- AWS Secrets Manager (~$0.40/secret/month)

Estimate ~$30-50/month for basic usage.