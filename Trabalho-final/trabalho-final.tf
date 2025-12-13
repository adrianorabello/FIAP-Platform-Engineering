module "project" {
  source = "./project"

  aws_region = "us-east-1"

  aws_amis = {
    us-east-1 = "ami-087c17d1fe0178315"
    us-west-2 = "ami-06b94666"
    eu-west-1 = "ami-844e0bf7"
  }

  web_instance_count = terraform.workspace == "prod" ? 3 : 1

  KEY_NAME          = "vockey"
  PATH_TO_KEY       = "/home/vscode/.ssh/vockey.pem"
  INSTANCE_USERNAME = "ec2-user"
}
