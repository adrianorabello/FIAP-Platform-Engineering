variable "aws_region" {
  description = "The AWS region to create things in."
  default     = "us-east-1"
}

variable "aws_amis" {
 description = "Map of AMIs per region"
 type        = map(string)
}

variable "KEY_NAME" {
  default = "vockey"
}
variable "PATH_TO_KEY" {
  default = "/home/vscode/.ssh/vockey.pem"
}
variable "INSTANCE_USERNAME" {
  default = "ec2-user"
}

variable "web_instance_count" {
  description = "Number of EC2 web instances"
  type        = number
  default     = 3
}



