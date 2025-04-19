provider "aws" {
  region = var.region
}

# Create a VPC for the RDS instance
resource "aws_vpc" "rds_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "rds-vpc"
  }
}

# Create an internet gateway
resource "aws_internet_gateway" "rds_igw" {
  vpc_id = aws_vpc.rds_vpc.id
  tags = {
    Name = "rds-igw"
  }
}

# Create a public subnet for RDS
resource "aws_subnet" "rds_subnet_1" {
  vpc_id                  = aws_vpc.rds_vpc.id
  cidr_block              = var.subnet_cidr_1
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true
  tags = {
    Name = "rds-subnet-1"
  }
}

# Create a second public subnet for RDS (required for DB subnet group)
resource "aws_subnet" "rds_subnet_2" {
  vpc_id                  = aws_vpc.rds_vpc.id
  cidr_block              = var.subnet_cidr_2
  availability_zone       = "${var.region}b"
  map_public_ip_on_launch = true
  tags = {
    Name = "rds-subnet-2"
  }
}

# Create a route table for the public subnets
resource "aws_route_table" "rds_route_table" {
  vpc_id = aws_vpc.rds_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.rds_igw.id
  }

  tags = {
    Name = "rds-route-table"
  }
}

# Associate the route table with the subnets
resource "aws_route_table_association" "rds_route_table_assoc_1" {
  subnet_id      = aws_subnet.rds_subnet_1.id
  route_table_id = aws_route_table.rds_route_table.id
}

resource "aws_route_table_association" "rds_route_table_assoc_2" {
  subnet_id      = aws_subnet.rds_subnet_2.id
  route_table_id = aws_route_table.rds_route_table.id
}

# Create a DB subnet group
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.rds_subnet_1.id, aws_subnet.rds_subnet_2.id]

  tags = {
    Name = "RDS Subnet Group"
  }
}

# Create a security group for RDS
resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group"
  description = "Allow inbound traffic to RDS"
  vpc_id      = aws_vpc.rds_vpc.id

  # Allow MySQL/Aurora traffic
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow PostgreSQL traffic
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-sg"
  }
}

# Create an RDS instance
resource "aws_db_instance" "default" {
  allocated_storage       = var.allocated_storage
  storage_type            = "gp2"
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  identifier              = var.identifier
  username                = var.username
  password                = var.password
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  skip_final_snapshot     = true
  publicly_accessible     = true
  backup_retention_period = 0
  apply_immediately       = true

  tags = {
    Name = "rds-instance"
  }
} 