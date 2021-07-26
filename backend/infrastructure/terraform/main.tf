terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  access_key = "AKIA3WRCM2HUGNQRHQ7C"
  secret_key = "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"
  region  = "us-east-1"
}

resource "aws_instance" "app_server" {
  ami           = "ami-830c94e3"
  instance_type = "t2.micro"

  tags = {
    Name = "ExampleAppServerInstance"
  }
}