terraform {
  backend "s3" {
    bucket = "fiap-terraform-state"
    key    = "project/${terraform.workspace}/terraform.tfstate"
    region = "us-east-1"
  }
}

module "project" {
  source = "../project"

  aws_region = "us-east-1"

  aws_amis = {
    us-east-1 = "ami-087c17d1fe0178315"
    us-west-2 = "ami-06b94666"
    eu-west-1 = "ami-844e0bf7"
  }

  web_instance_count = terraform.workspace == "prod" ? 3 : 1

  key_name          = "vockey"
  path_to_key       = "/home/vscode/.ssh/vockey.pem"
  instance_username = "ec2-user"
}
