# AWS RDS and ECS Task Manager Application with Terraform

A production-ready, full-stack web application demonstrating cloud-native deployment with AWS infrastructure as code using Terraform. This project combines containerized microservices architecture with relational database services.

## 🚀 AWS Cloud Architecture

This project creates a complete web application stack in AWS using Terraform:
- **Amazon RDS MySQL database** with public access for persistent data storage
- **Express.js RESTful API** for task management with a modern Bootstrap UI
- **AWS ECS Fargate** deployment with auto-scaling for serverless container orchestration
- **Application Load Balancer** for intelligent traffic distribution
- **Terraform IaC** (Infrastructure as Code) for reproducible deployments

## 📋 Application Features

- Modern responsive UI built with Bootstrap 5
- RESTful API for task management:
  - List all tasks with ordered pagination
  - Create new tasks with validation
  - Delete existing tasks with confirmation
- Automatic database initialization and migration
- Health check endpoint for container orchestration
- Containerized with Docker for consistent deployment

## ☁️ AWS Services Used

This project utilizes the following AWS services:

1. **Amazon RDS (Relational Database Service)**
   - MySQL database engine
   - Stores task data persistently
   - Automatically handles backups and maintenance

2. **Amazon ECS (Elastic Container Service)**
   - Orchestrates and manages Docker containers
   - Handles deployment, scaling, and management of the application

3. **AWS Fargate**
   - Serverless compute engine for containers
   - Runs containers without managing servers or clusters

4. **Amazon ECR (Elastic Container Registry)**
   - Stores, manages, and deploys Docker container images
   - Integrates with ECS for seamless deployment

5. **Elastic Load Balancing (ALB)**
   - Application Load Balancer to distribute traffic
   - Routes HTTP requests to ECS tasks
   - Performs health checks on the application

6. **Amazon VPC (Virtual Private Cloud)**
   - Provides isolated network infrastructure
   - Manages subnets, route tables, and internet gateways

7. **AWS IAM (Identity and Access Management)**
   - Manages access permissions through roles
   - ECS task execution role for container deployment

8. **Amazon CloudWatch**
   - Collects and tracks logs from ECS tasks
   - Monitors application performance

## 🏗️ Infrastructure Components

- **Database Layer**: 
  - RDS MySQL instance
  - VPC, subnets, security groups for database access
  
- **Application Layer**:
  - ECR repository for container images
  - ECS Fargate cluster, tasks, and services
  - CloudWatch logs integration
  
- **Networking Layer**:
  - Application Load Balancer
  - Target groups and listeners
  - Security groups for network access

## 📋 Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed (v0.12+)
- AWS credentials configured (`AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables or AWS CLI configured)
- [Docker](https://www.docker.com/get-started) installed (for building and pushing the application image)
- [AWS CLI](https://aws.amazon.com/cli/) configured

## 📝 Step-by-Step Deployment Guide

### 1. Clone the Repository

```
git clone <repository-url>
cd appwithdb_ECS
```

### 2. Infrastructure Deployment

1. Initialize Terraform:
   ```
   terraform init
   ```

2. Apply the infrastructure:
   ```
   terraform apply -auto-approve
   ```

   This will create all necessary AWS resources including:
   - VPC, subnets, and security groups
   - RDS MySQL database
   - ECR repository
   - ECS cluster, task definition, and service
   - Application Load Balancer

3. Note the outputs:
   ```
   terraform output
   ```
   
   Key outputs include:
   - `ecr_repository_url`: URL of the ECR repository
   - `alb_dns_name`: DNS name of the Application Load Balancer
   - `rds_endpoint`: Endpoint of the RDS instance

### 3. Build and Push Docker Image

1. Navigate to the app directory:
   ```
   cd app
   ```

2. Ensure the public directory exists:
   ```
   # For Linux/Mac
   mkdir -p public
   
   # For Windows
   New-Item -ItemType Directory -Force -Path public
   ```

3. Authenticate with Amazon ECR:
   ```
   # For Linux/Mac
   aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <ecr-repository-url>
   
   # For Windows
   aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <ecr-repository-url>
   ```

4. Build the Docker image:
   ```
   docker build -t <ecr-repository-url>:latest .
   ```

5. Push the image to ECR:
   ```
   docker push <ecr-repository-url>:latest
   ```

### 4. Access the Application

1. Wait a few minutes for the ECS service to pull the image and start the tasks
2. Access the application at the ALB DNS name:
   ```
   http://<alb-dns-name>
   ```
   
   For example: `http://task-manager-alb-123456789.us-east-1.elb.amazonaws.com`

### 5. Test the Application

1. Add tasks using the form on the left
2. View and delete tasks on the right
3. The tasks are stored in the RDS MySQL database

## 🪟 Windows-Specific Instructions

If you're using Windows, use PowerShell commands:

```powershell
# Get terraform outputs
$ECR_REPO_URL = terraform output -raw ecr_repository_url
$AWS_REGION = terraform output -raw aws_region
$ACCOUNT_ID = aws sts get-caller-identity --query Account --output text

# Create directories if they don't exist
if (-not (Test-Path -Path app/public)) { New-Item -ItemType Directory -Force -Path app/public }

# Authenticate with ECR
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO_URL

# Build and push Docker image
cd app
docker build -t $ECR_REPO_URL:latest .
docker push $ECR_REPO_URL:latest
```

## 🧹 Clean Up

To tear down all resources and avoid incurring charges:

```
terraform destroy -auto-approve
```

## ⚠️ Security Note

This configuration creates resources with public access for demonstration purposes. For production environments:

1. Use private subnets for the RDS instance and ECS tasks
2. Restrict security group access to specific IP ranges
3. Add a proper authentication system to the application
4. Consider using AWS Secrets Manager for storing database credentials

## 💼 Use Cases

This project serves as an excellent foundation for:

- Microservices architecture on AWS
- CI/CD pipeline integration
- DevOps practices demonstration
- Infrastructure as Code (IaC) learning
- Containerization and orchestration
- Cloud-native application development

## 🔍 Keywords

AWS, RDS, ECS, Fargate, Terraform, Docker, Node.js, Express.js, Microservices, Cloud, DevOps, Infrastructure as Code, Containerization, Bootstrap, Full-stack, Web Application, Task Manager, MySQL, ECR, Load Balancer, VPC, IAM, CloudWatch, RESTful API