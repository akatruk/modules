resource "aws_rds_cluster" "template-aurora" {
  availability_zones = [
    "eu-west-2a",
    "eu-west-2b",
    "eu-west-2c",
  ]
  backtrack_window                    = 0
  backup_retention_period             = 7
  cluster_identifier                  = "${var.cluster_name}"
  copy_tags_to_snapshot               = true
  db_cluster_parameter_group_name     = "default.aurora-postgresql${var.rds_version}"
  db_subnet_group_name                = "production-subnet-group"
  deletion_protection                 = true
  enable_http_endpoint                = false
  enabled_cloudwatch_logs_exports     = []
  engine                              = "aurora-postgresql"
  engine_mode                         = "provisioned"
  engine_version                      = "${var.rds_version}.6"
  iam_database_authentication_enabled = false
  iam_roles                           = []
  master_username                     = "${var.default_username}"
  master_password                     = random_password.master_password.result
  port                                = 5432
  preferred_backup_window             = "23:40-00:10"
  preferred_maintenance_window        = "sun:00:55-sun:01:25"
  skip_final_snapshot                 = true
  storage_encrypted                   = true
  tags = (merge(
    "${var.common_tags}")
  )
  vpc_security_group_ids = [
    data.aws_security_group.kube_node.id,
  ]
  lifecycle {
    ignore_changes = [
      engine_version,
      engine_version_actual,
      preferred_backup_window,
      preferred_maintenance_window,
    ]
  }

}

resource "aws_security_group" "template-aurora-sg" {
  name   = "${var.cluster_name}-sg"
  egress = []
  ingress = [
    {
      cidr_blocks = [
        "10.19.0.0/16",
      ]
      description      = ""
      from_port        = 5432
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 5432
    },
    {
      cidr_blocks = [
        "172.16.0.0/16",
      ]
      description      = ""
      from_port        = 5432
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 5432
    },
  ]
  tags = (merge(
    "${var.common_tags}")
  )
  vpc_id = data.terraform_remote_state.vpc.outputs.kube_vpc_id
}

resource "aws_rds_cluster_instance" "template-aurora-instance-1" {
  count                                 = var.replicas_count
  auto_minor_version_upgrade            = true
  availability_zone                     = "eu-west-2c"
  ca_cert_identifier                    = "rds-ca-2019"
  cluster_identifier                    = aws_rds_cluster.template-aurora.cluster_identifier
  copy_tags_to_snapshot                 = false
  db_parameter_group_name               = "default.aurora-postgresql${var.rds_version}"
  db_subnet_group_name                  = "production-subnet-group"
  engine                                = "aurora-postgresql"
  engine_version                        = "${var.rds_version}.6"
  identifier                            = "${aws_rds_cluster.template-aurora.cluster_identifier}-${count.index + 1}"
  instance_class                        = var.instance_class
  performance_insights_enabled          = true
  performance_insights_retention_period = 7
  promotion_tier                        = 1
  publicly_accessible                   = false
  tags = (merge(
    "${var.common_tags}")
  )
  lifecycle {
    ignore_changes = [
      engine_version,
    ]
  }
}

resource "random_password" "template-master-password" {
  length  = 16
  special = false
}

resource "aws_secretsmanager_secret" "template-aurora" {
  name = "${aws_rds_cluster.template-aurora.cluster_identifier}-rds"
  tags = (merge(
    "${var.common_tags}")
  )
}

resource "aws_secretsmanager_secret_version" "template-aurora" {
  secret_id     = aws_secretsmanager_secret.template-aurora.id
  secret_string = <<EOF
{
  "username": "${aws_rds_cluster.template-aurora.master_username}",
  "password": "${random_password.master_password.result}",
  "host": "${aws_rds_cluster.template-aurora.endpoint}",
  "port": ${aws_rds_cluster.template-aurora.port},
  "dbClusterIdentifier": "${aws_rds_cluster.template-aurora.cluster_identifier}"
}
EOF
}
