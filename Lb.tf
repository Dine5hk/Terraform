provider "aws" {
  region = "ap-south-1"  # Mumbai region
}

# Define a security group for the load balancer and instances
resource "aws_security_group" "sg" {
  name_prefix = "terraform-sg-"
  vpc_id      = "vpc-0164a6ca231aa6b06"  # Replace with your VPC ID

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create a Load Balancer
resource "aws_lb" "main" {
  name               = "terraform-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg.id]
  subnets            = ["subnet-00da1a9a199d821ec", "subnet-0a710c9ceae0f1ded"]  # Replace with your Subnet IDs

  enable_deletion_protection = false
  idle_timeout               = 400
  drop_invalid_header_fields = true
}

# Create a Load Balancer Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Hello, World!"
      status_code  = "200"
    }
  }
}

# Define a Load Balancer Target Group
resource "aws_lb_target_group" "target_group" {
  name     = "terraform-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-0164a6ca231aa6b06"  # Replace with your VPC ID

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# Define an Auto Scaling Launch Configuration
resource "aws_launch_configuration" "app" {
  name          = "terraform-lc"
  image_id      = "ami-0c2af51e265bd5e0e"  # Replace with your AMI ID
  instance_type = "t2.micro"
  security_groups = [aws_security_group.sg.id]
  key_name       = "terraform"  # Replace with your EC2 key pair name

  lifecycle {
    create_before_destroy = true
  }
}


