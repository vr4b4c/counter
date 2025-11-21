# Terraform Configuration for Counter Service on AWS ECS

This Terraform configuration deploys the counter service to AWS ECS with the following components:

- **ECS Fargate Cluster**: Serverless container hosting
- **Application Load Balancer**: Public-facing load balancer
- **ElastiCache Redis**: Managed Redis cluster for state storage
- **CloudWatch Logs**: Centralized logging
- **IAM Roles**: Proper permissions for ECS tasks

## Prerequisites

1. AWS CLI configured with appropriate credentials
2. Terraform >= 1.0 installed
3. Docker image pushed to ECR (or use a public image)

## Setup

1. Copy the example variables file:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. Edit `terraform.tfvars` and set your values:
   - `container_image`: Your ECR repository URI (e.g., `123456789012.dkr.ecr.us-east-1.amazonaws.com/counter:latest`)
   - `aws_region`: Your preferred AWS region
   - Adjust other variables as needed

3. Initialize Terraform:
   ```bash
   cd terraform
   terraform init
   ```

4. Review the plan:
   ```bash
   terraform plan
   ```

5. Apply the configuration:
   ```bash
   terraform apply
   ```

## Building and Pushing Docker Image

Before deploying, you need to build and push your Docker image to ECR. You can use the provided helper script:

```bash
cd terraform
./setup-ecr.sh
```

Or manually:

```bash
# Authenticate Docker to ECR
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin YOUR_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com

# Create ECR repository (if it doesn't exist)
aws ecr create-repository --repository-name counter --region us-east-1

# Build the image (from project root)
docker build -t counter:latest .

# Tag the image
docker tag counter:latest YOUR_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/counter:latest

# Push the image
docker push YOUR_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/counter:latest
```

Then update `container_image` in `terraform.tfvars` with the ECR URI.

## Outputs

After deployment, Terraform will output:
- `alb_url`: The public URL to access your application
- `ecs_cluster_name`: Name of the ECS cluster
- `ecs_service_name`: Name of the ECS service
- `redis_endpoint`: Redis endpoint (sensitive)

## Variables

See `variables.tf` for all available variables and their descriptions.

## Cleanup

To destroy all resources:
```bash
terraform destroy
```

## Notes

- The configuration uses the default VPC by default. You can specify a custom VPC using the `vpc_id` variable.
- Redis is configured with encryption at rest and in transit.
- The ALB listens on port 80 (HTTP). For HTTPS, you'll need to add an SSL certificate and configure the listener.
- Health checks are configured for both the ALB target group and ECS container.

