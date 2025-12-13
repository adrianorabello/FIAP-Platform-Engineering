provider "aws" {
  region = var.aws_region
}

variable "project" {
  default = "fiap-lab"
}

data "aws_vpc" "vpc" {
  tags = {
    Name = var.project
  }
}

data "aws_subnets" "all" {
  filter {
    name   = "tag:Tier"
    values = ["Public"]
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
}

data "aws_subnet" "public" {
  for_each = toset(data.aws_subnets.all.ids)
  id       = each.value
}

resource "random_shuffle" "random_subnet" {
  input        = [for s in data.aws_subnet.public : s.id]
  result_count = 1
}

# 🔹 ELB com nome baseado no workspace
resource "aws_elb" "web" {
  name = "elb-${terraform.workspace}"

  subnets         = data.aws_subnets.all.ids
  security_groups = [aws_security_group.allow-ssh.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 6
  }

  instances = aws_instance.web[*].id
}


resource "aws_instance" "web" {
  count         = var.web_instance_count
  instance_type = "t3.micro"
  ami           = lookup(var.aws_amis, var.aws_region)

  subnet_id              = random_shuffle.random_subnet.result[0]
  vpc_security_group_ids = [aws_security_group.allow-ssh.id]
  key_name               = var.KEY_NAME

  user_data = <<-EOF
    #!/bin/bash
    yum install -y nginx
    systemctl enable nginx
    systemctl start nginx

    cat <<HTML > /usr/share/nginx/html/index.html
    <html>
      <body style="font-family: Arial;">
        <h1>NGINX UP </h1>
        <p>Workspace: ${terraform.workspace}</p>
        <p>Instance: nginx-workspace-${terraform.workspace}-${count.index + 1}</p>
      </body>
    </html>
    HTML
  EOF

  

  tags = {
    Name = format(
      "nginx-workspace-%s-%03d",
      terraform.workspace,
      count.index + 1
    )
  }
}


