variable "cluster_name" {
  default = "template_rds"
}

variable "default_username" {
  default = "postgres"
}

variable "rds_version" {
  default = "13"
}

variable "instance_class" {
  default = "db.r6g.4xlarge"
}

variable "replicas_count" {
  default = "1"
}

variable "var-project" {
  default = "test-project"
}

variable "var-owner" {
  default = "DevOps team"
}

variable "var-app-owner" {
  default = "Andrei Katruk"
}
