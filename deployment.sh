#!/bin/bash
set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Task Manager Application Deployment${NC}"
echo "-----------------------------------"

# Step 1: Apply Terraform infrastructure
echo -e "${GREEN}Step 1: Deploying infrastructure with Terraform...${NC}"
terraform init
terraform apply -auto-approve

# Step 2: Get the outputs
echo -e "${GREEN}Step 2: Retrieving deployment information...${NC}"
ECR_REPO_URL=$(terraform output -raw ecr_repository_url)
AWS_REGION=$(terraform output -raw aws_region 2>/dev/null || echo "us-east-1")
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

echo "ECR Repository URL: $ECR_REPO_URL"
echo "AWS Region: $AWS_REGION"

# Step 3: Build and push Docker image
echo -e "${GREEN}Step 3: Building and pushing Docker image...${NC}"
cd app

# Authenticate with ECR
echo "Logging in to Amazon ECR..."
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

# Build the Docker image
echo "Building Docker image..."
docker build -t $ECR_REPO_URL:latest .

# Push the image to ECR
echo "Pushing to ECR..."
docker push $ECR_REPO_URL:latest

cd ..

# Step 4: Get the application URL
echo -e "${GREEN}Step 4: Getting application access details...${NC}"
ALB_DNS=$(terraform output -raw alb_dns_name)
RDS_ENDPOINT=$(terraform output -raw rds_endpoint)

echo -e "${YELLOW}Deployment completed!${NC}"
echo "-----------------------------------"
echo "Application URL: http://$ALB_DNS"
echo "RDS Endpoint: $RDS_ENDPOINT"
echo ""
echo "Note: It may take a few minutes for the ECS service to start the tasks and for the ALB to register targets."
echo "You can check the status in the AWS Console." 