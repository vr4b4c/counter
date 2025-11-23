resource "aws_lb_target_group" "app" {
  name        = "${var.app_name}-${var.env_id}-tg"
  port        = 9292
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.default.id
  target_type = "ip"

  tags = {
    Name = "${var.app_name}-${var.env_id}-tg"
  }
}

resource "aws_lb_listener_rule" "app" {
  listener_arn = var.alb_listener_arn
  # Generate a unique priority based on env_id to avoid conflicts
  # Using modulo to keep priority in valid range (1-50000, but keeping it reasonable)
  priority = tonumber("0x${substr(md5("${var.app_name}-${var.env_id}"), 0, 8)}") % 500 + 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }

  condition {
    host_header {
      values = ["${var.app_name}-${var.env_id}.${var.domain}"]
    }
  }
}
