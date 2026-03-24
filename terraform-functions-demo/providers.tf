# Exam Concept: Provider Aliases
# Allows multiple configurations for the same provider (e.g., dual regions)

provider "random" {
  # Default configuration
}

provider "random" {
  alias = "custom"
  # You could set specific settings here if supported by the provider
}

provider "null" {
  # Standard configuration
}
