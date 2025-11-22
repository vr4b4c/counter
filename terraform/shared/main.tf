terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    region = "eu-central-1"
    bucket = "terraform-counter"
    key    = "envs/shared.tfstate"
  }
}
