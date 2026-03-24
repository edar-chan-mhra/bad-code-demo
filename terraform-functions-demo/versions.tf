terraform {
  # Exam Concept: Version constraints
  # ~> 1.0 means >= 1.0.0 and < 1.1.0 (lazy increment)
  required_version = "~> 1.0"

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }

  # Exam Concept: Backend block (state management)
  # Standard backends: local, s3, azurerm, gcs, etc.
  # Note: A backend block cannot contain interpolations (variables).
  backend "local" {
    path = "terraform.tfstate"
  }
}
