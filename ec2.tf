resource "aws_security_group" "example_sg" {
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
}

resource "aws_instance" "app_server" {
  ami           = "ami-0c2af51e265bd5e0e"
  instance_type = "t2.medium"
  count         = 2
  vpc_security_group_ids = [aws_security_group.example_sg.id]

  root_block_device {
    volume_size = 50
    volume_type = "gp2"
  }

  tags = {
    Name = "terraform-${count.index + 1}"
  }
}

output "instance_ids" {
  value = aws_instance.app_server[*].id
}

output "instance_public_ips" {
  value = aws_instance.app_server[*].public_ip
}
