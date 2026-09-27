terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.16.0"
    }
  }

  backend "s3" {
    bucket       = "remote-state-chakra-prod" 
    key          = "tfvars-multi-env-demo"
    region       = "us-east-1"
    encrypt      = true                  # Forces server-side encryption of the state file
    use_lockfile = true                  # Enables native S3 state locking (replaces DynamoDB)
  }
}

# The AWS Provider Configuration
provider "aws" {
  region = "us-east-1"
}