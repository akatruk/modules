RDS: 

RDS example

```
module "rds" {
  source           = "git@github.com:akatruk/modules.git//rds"
  cluster_name     = "test_rds"
  default_username = "postgres"
  rds_version      = "13"
  instance_class   = "db.r6g.large"
  replicas_count   = 1
  common_tags = {
    project = "test-project"
    owner     = "DevOps team"
    app-owner = "Andrei Katruk"
  }
}
```
