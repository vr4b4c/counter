resource "aws_cloudwatch_log_group" "app" {
  name              = "/ecs/${var.app_name}-${var.env_id}"
  retention_in_days = 7
  tags = {
    Name = "${var.app_name}-${var.env_id}-logs"
  }
}
