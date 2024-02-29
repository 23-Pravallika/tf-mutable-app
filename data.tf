data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "buck-tf-state"
    key = "vpc/${var.ENV}/terraform.tfstate"
    region = "us-east-1"
    }
}

data "terraform_remote_state" "db" {
  backend = "s3"

  config = {
    bucket = "buck-tf-state"
    key    = "databases/${var.ENV}/terraform.tfstate"
    region = "us-east-1"
    }
}

data "terraform_remote_state" "alb" {
  backend = "s3"

  config = {
    bucket = "buck-tf-state"
    key = "alb/${var.ENV}/terraform.tfstate"
    region = "us-east-1"
    }
}


data "aws_ami" "my_ami" {
  most_recent      = true
  name_regex       = "ansible-installed-ami"
  owners           = ["self"]
}

data "aws_secretsmanager_secret" "secrets" {
   name   =  "robo/secret"
}

data "aws_secretsmanager_secret_version" "secrets" {
  secret_id     = data.aws_secretsmanager_secret.secrets.id
}

