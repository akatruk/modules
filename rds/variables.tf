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

variable "not_default_tags" {
  type = list(object({
    project   = number
    owner     = number
    app_owner = string
    app-tasks = "undefined"
  }))
  default = [
    {
      project   = "test-project"
      owner     = "DevOps team"
      app_owner = "Andrei Katruk"
      app-tasks = "undefined"
    }
  ]
}