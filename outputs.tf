output "rds_endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.default.endpoint
}

output "rds_port" {
  description = "RDS instance port"
  value       = aws_db_instance.default.port
}

output "rds_username" {
  description = "RDS instance master username"
  value       = aws_db_instance.default.username
}

output "rds_database_name" {
  description = "RDS instance database name"
  value       = aws_db_instance.default.db_name
}

output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = aws_ecr_repository.app_repo.repository_url
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.app_lb.dns_name
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.app_cluster.name
}

output "ecs_service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.app_service.name
}

output "aws_region" {
  description = "AWS region used for deployment"
  value       = var.region
} 