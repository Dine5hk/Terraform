# creation instance & security group  with default vpc

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "terraform" {
  name        = "terraform-group"
  description = "Security group terraform"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 10000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 25
    to_port     = 25
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 465
    to_port     = 465
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allows all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "app_server" {
  ami           = "ami-0c2af51e265bd5e0e"
  instance_type = "t2.medium"
  count         = 2
  key_name      = "terraform"
  vpc_security_group_ids = [aws_security_group.terraform.id]

  root_block_device {
    volume_size = 50
    volume_type = "gp2"
  }

  tags = {
    Name = "terra"
  }
}

resource "aws_instance" "server" {
  ami           = "ami-0c2af51e265bd5e0e"
  instance_type = "t2.micro"
  count         = 2
  key_name      = "terraform"
  vpc_security_group_ids = [aws_security_group.terraform.id]

  root_block_device {
    volume_size = 50
    volume_type = "gp2"
  }

  tags = {
    Name = "jenkins"
  }
}

output "instance_ids" {
  value = aws_instance.app_server[*].id
}

output "instance_public_ips" {
  value = aws_instance.app_server[*].public_ip
}
