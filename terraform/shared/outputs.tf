output "alb_url" {
  description = "URL of the Application Load Balancer"
  value       = "http://${aws_lb.main.dns_name}"
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.main.arn
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.main.dns_name
}

output "alb_sg_id" {
  description = "Security group of the Application Load Balancer"
  value       = aws_security_group.alb.id
}

output "alb_listener_arn" {
  description = "ARN of the default ALB listener on port 80"
  value       = aws_lb_listener.default.arn
}

output "redis_url" {
  description = "Redis URL"
  value       = "redis://${aws_elasticache_cluster.redis.cache_nodes.0.address}:6379"
}

output "ecs_cluster_id" {
  description = "ECS Cluster ID"
  value       = aws_ecs_cluster.main.id
}

output "redis_sg_id" {
  description = "Security group ID for Redis"
  value       = aws_security_group.redis.id
}
