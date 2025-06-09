# Prodigy Hosted Template

A template for deploying Prodigy annotation projects to AWS EC2 with S3 storage.

## Features

- Dockerized Prodigy application
- AWS EC2 deployment with Terraform
- S3 integration for data storage
- Automated deployment scripts
- Configurable annotation projects

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform installed
- Docker and Docker Compose
- SSH key pair for EC2 access

## Quick Start

1. **Clone and configure:**
   ```bash
   git clone <this-repo>
   cd prodigy-hosted-template
   cp .env.example .env
   # Edit .env with your configuration
   ```

2. **Deploy infrastructure:**
   ```bash
   ./scripts/deploy.sh [project-name] [path-to-ssh-public-key]
   ```

3. **Access Prodigy:**
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

- Default security group allows access from anywhere (0.0.0.0/0)
- Modify `ssh_cidr_blocks` in `terraform/variables.tf` to restrict access
- Consider using AWS IAM roles for production deployments

## Costs

Running costs depend on:
- EC2 instance type (default: t3.medium)
- S3 storage usage
- Data transfer

Estimate ~$30-50/month for basic usage.