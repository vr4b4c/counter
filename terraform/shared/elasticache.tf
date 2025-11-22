resource "aws_security_group" "redis" {
  name        = "${var.app_name}-redis-sg"
  description = "Security group for ElastiCache Redis"
  vpc_id      = data.aws_vpc.default.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.app_name}-redis-sg"
  }
}

resource "aws_elasticache_subnet_group" "redis" {
  name       = "${var.app_name}-redis-subnet-group"
  subnet_ids = data.aws_subnets.default.ids

  tags = {
    Name = "${var.app_name}-redis-subnet-group"
  }
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id                 = "${var.app_name}-redis"
  engine                     = "redis"
  engine_version             = "7.1"
  node_type                  = "cache.t2.micro"
  port                       = 6379
  parameter_group_name       = "default.redis7"
  num_cache_nodes            = 1
  subnet_group_name          = aws_elasticache_subnet_group.redis.name
  security_group_ids         = [aws_security_group.redis.id]

  tags = {
    Name = "${var.app_name}-redis"
  }
}
