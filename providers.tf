terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region     = "eu-north-1"
  #mettre sa clé d'accès 
  access_key = "access_key"
  secret_key = "secret_key"
}