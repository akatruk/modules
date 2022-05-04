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

# variable "tags" {
#   type = list(object({
#     project   = string
#     owner     = string
#     app_owner = string
#     app-tasks = string
#   }))
#   default = [
#     {
#       project   = "test-project"
#     owner     = "test-owner"
#     app_owner = "test-app_owner"
#     app-tasks = "test-app-tasks"
#     }
#   ]
# }

variable "tags" {}