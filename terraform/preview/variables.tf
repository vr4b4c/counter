variable "project" {
  description = "Name of a project"
  type        = string
  default     = "counter"
}

variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "eu-central-1"
}

variable "container_image" {
  description = "Docker image URI for the container"
  type        = string
  default     = ""
}

variable "app_name" {
  description = "Name of the application"
  type        = string
  default     = "counter"
}

variable "hosted_zone_id" {
  description = "Route53 hosted zone id"
  type        = string
}

variable "env_id" {
  description = "Environment ID"
  type        = string
}

variable "domain" {
  description = "Domain"
  type        = string
}

variable "redis_url" {
  description = "Redis URL" # rediss://${aws_elasticache_replication_group.redis.primary_endpoint_address}:6379

  type = string
}

variable "ecs_cluster_id" {
  description = "ECS Cluster ID"
  type        = string
}

variable "alb_arn" {
  description = "ARN of the Application Load Balancer"
  type        = string
}

variable "alb_sg_id" {
  description = "Security group of the Application Load Balancer"
  type        = string
}

variable "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  type        = string
}

variable "redis_sg_id" {
  description = "Security group ID for Redis"
  type        = string
}
