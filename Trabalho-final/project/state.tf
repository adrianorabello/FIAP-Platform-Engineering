terraform {
  backend "s3" {
    bucket = "mba-fiap-trabalho-final"
    key    = "teste"
    region = "us-east-1"
  }
}