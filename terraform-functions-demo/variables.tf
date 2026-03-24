variable "app_name" {
  type        = string
  description = "Name of the application"
  default     = "exam-demo-app"
}

# Exam Concept: Type Constraints (list, map, object, tuple)
variable "allowed_regions" {
  type    = list(string)
  default = ["us-east-1", "eu-west-1"]
}

# Exam Concept: Variable Validation
variable "environment" {
  type = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
  default = "dev"
}

# Exam Concept: Sensitive Variables (hidden in outputs/logs)
variable "db_password" {
  type      = string
  sensitive = true
  default   = "terraform-associate-004-secret"
}

# Exam Concept: Object Type
variable "server_config" {
  type = object({
    cpu    = number
    memory = number
    tags   = map(string)
  })
  default = {
    cpu    = 2
    memory = 4096
    tags   = {
      Proj = "ExamPrep"
    }
  }
}
