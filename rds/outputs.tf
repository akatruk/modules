output "rds_cluster_creads" {
  value = aws_secretsmanager_secret_version.template-aurora.id
}
