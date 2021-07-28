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
  region = "${var.region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

resource "aws_amplify_app" "nodely" {
  name       = "nodely"
  repository = "https://github.com/misodope/node.ly"
  access_token = "${var.github_access_token}"

  # The default build_spec added by the Amplify Console for React.
  build_spec = <<-EOT
    version: 0.1
    frontend:
      phases:
        preBuild:
          commands:
            - cd frontend
            - yarn
        build:
          commands:
            - yarn run build
      artifacts:
        baseDirectory: ./frontend/build
        files:
          - '**/*'
      cache:
        paths:
          - node_modules/**/*
  EOT

  enable_branch_auto_build = true

  # The default rewrites and redirects added by the Amplify Console.
  custom_rule {
    source = "/<*>"
    status = "404"
    target = "/index.html"
  }

  environment_variables = {
    ENV = "test"
  }
}

resource "aws_amplify_branch" "master" {
  app_id      = aws_amplify_app.nodely.id
  branch_name = "main"

  framework = "React"
  stage     = "PRODUCTION"

  basic_auth_config {

  }
}
