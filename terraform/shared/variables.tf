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
