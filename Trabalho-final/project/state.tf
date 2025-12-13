terraform {
  backend "s3" {
    bucket = "mba-fiap-trabalho-final"
    key    = "project/${terraform.workspace}/terraform.tfstate"
    region = "us-east-1"
  }
}
