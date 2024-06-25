terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.23"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}

/*backend "s3" {
    bucket         = "terraform-state"
    dynamodb_table = "terraform-locks"
    key            = "fxc/sandbox1.tfstate"
    region         = "eu-west-2"
}
*/