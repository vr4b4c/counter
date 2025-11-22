provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project   = var.project
      EnvId     = var.env_id
      Terraform = "True"
    }
  }
}
