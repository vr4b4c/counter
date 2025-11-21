#!/bin/bash
# Helper script to create ECR repository and push Docker image

set -e

# Configuration
AWS_REGION="${AWS_REGION:-eu-central-1}"
REPOSITORY_NAME="${REPOSITORY_NAME:-counter}"
IMAGE_TAG="${IMAGE_TAG:-$(date +"%Y-%m-%d-%H-%M-%S")}"

# Get AWS account ID
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

if [ -z "$ACCOUNT_ID" ]; then
  echo "Error: Could not get AWS account ID. Make sure AWS CLI is configured."
  exit 1
fi

ECR_URI="${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${REPOSITORY_NAME}"

echo "AWS Account ID: ${ACCOUNT_ID}"
echo "ECR Repository: ${ECR_URI}"
echo "Region: ${AWS_REGION}"
echo ""

# Check if repository exists, create if not
if aws ecr describe-repositories --repository-names "${REPOSITORY_NAME}" --region "${AWS_REGION}" 2>/dev/null; then
  echo "Repository ${REPOSITORY_NAME} already exists."
else
  echo "Creating ECR repository ${REPOSITORY_NAME}..."
  aws ecr create-repository \
    --repository-name "${REPOSITORY_NAME}" \
    --region "${AWS_REGION}" \
    --image-scanning-configuration scanOnPush=true
fi

# Authenticate Docker to ECR
echo "Authenticating Docker to ECR..."
aws ecr get-login-password --region "${AWS_REGION}" | \
  docker login --username AWS --password-stdin "${ECR_URI}"

# Build the image (from parent directory)
echo "Building Docker image..."
cd ..
ls
docker build -t "${REPOSITORY_NAME}:${IMAGE_TAG}" --platform linux/amd64 .

# Tag the image
echo "Tagging image..."
docker tag "${REPOSITORY_NAME}:${IMAGE_TAG}" "${ECR_URI}:${IMAGE_TAG}"
docker tag "${REPOSITORY_NAME}:${IMAGE_TAG}" "${ECR_URI}:latest"

# Push the image
echo "Pushing image to ECR..."
docker push "${ECR_URI}:${IMAGE_TAG}"

echo ""
echo "✓ Image pushed successfully!"
echo ""
echo "Updating terraform.tfvars with:"
echo "  container_image = \"${ECR_URI}:${IMAGE_TAG}\""
echo "  container_image = \"${ECR_URI}:${IMAGE_TAG}\"" > terraform/terraform.tfvars

