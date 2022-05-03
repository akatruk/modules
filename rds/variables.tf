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

variable "allow_cidr_one" {
  default = "10.19.0.0/16"
}

variable "allow_cidr_two" {
  default = "172.16.0.0/16"
}

variable "not_default_tags" {
  type = list(object({
    project   = string
    owner     = string
    app_owner = string
    app-tasks = string
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

