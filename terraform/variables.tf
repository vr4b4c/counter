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

variable "app_name" {
  description = "Name of the application"
  type        = string
  default     = "counter"
}

variable "container_image" {
  description = "Docker image URI for the container"
  type        = string
  default     = ""
}

variable "use_default_vpc" {
  description = "Whether to use the default VPC"
  type        = bool
  default     = true
}

variable "vpc_id" {
  description = "VPC ID to use (leave empty if using default VPC)"
  type        = string
  default     = ""
}

variable "task_cpu" {
  description = "CPU units for the ECS task (1024 = 1 vCPU)"
  type        = number
  default     = 256
}

variable "task_memory" {
  description = "Memory for the ECS task in MB"
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "Desired number of ECS tasks"
  type        = number
  default     = 1
}

variable "redis_node_type" {
  description = "ElastiCache Redis node type"
  type        = string
  default     = "cache.t2.micro"
}

variable "redis_num_cache_clusters" {
  description = "Number of cache clusters in the ElastiCache replication group"
  type        = number
  default     = 1
}

variable "log_retention_days" {
  description = "CloudWatch log retention in days"
  type        = number
  default     = 7
}

variable "enable_container_insights" {
  description = "Enable CloudWatch Container Insights for ECS cluster"
  type        = bool
  default     = false
}

