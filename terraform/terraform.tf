terraform {
  required_version = "~> 1.5.4"
  required_providers {
    aws = {
      version = "~> 5.10.0"
      source  = "hashicorp/aws"
    }
  }
}
