resource "aws_elasticache_parameter_group" "elasticache_parameter_group" {
  name   = "${var.project}-${var.enviroment}-elasticache-parameter-group"
  family = "redis5.0"

  parameter {
    name  = "cluster-enabled"
    value = "no"
  }
}

resource "aws_elasticache_subnet_group" "elasticache_subnet_group" {
  name = "${var.project}-${var.enviroment}-elasticache-subnet-group"
  subnet_ids = [
    aws_subnet.private-rds-subnet-1a.id,
    aws_subnet.private-rds-subnet-1c.id
  ]
}

resource "aws_elasticache_replication_group" "elasticache_replication_group" {
  replication_group_id     = "${var.project}-${var.enviroment}-elasticache"
  description = "redis"
  engine                   = "redis"
  engine_version           = "5.0.4"
  num_cache_clusters       = 3
  node_type                = "cache.t3.medium"
  snapshot_window          = "04:00-05:00"
  snapshot_retention_limit = 3
  maintenance_window       = "Mon:05:00-Mon:08:00"
  # プライマリノードが落ちた時にレプリカノードに切り替える
  automatic_failover_enabled = true
  port                       = 6379
  apply_immediately          = true
  security_group_ids         = [aws_security_group.elasticache_sg.id]
  parameter_group_name       = aws_elasticache_parameter_group.elasticache_parameter_group.name
  subnet_group_name          = aws_elasticache_subnet_group.elasticache_subnet_group.name
}
