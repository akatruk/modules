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
    owner     = "test-owner"
    app_owner = "test-app_owner"
    app-tasks = "test-app-tasks"
    }
  ]
}