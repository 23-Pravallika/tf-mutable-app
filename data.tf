data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "buck-tf-state"
    key = "vpc/${var.ENV}/terraform.tfstate"
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
  name_regex       = "Lab-ansible-ami"
  owners           = ["self"]
}


