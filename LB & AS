
# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "my-vpc"
  }
}

# Create a Security Group
resource "aws_security_group" "allow_all" {
  vpc_id = aws_vpc.main.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
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
  tags = {
    Name = "allow_all"
  }
}

# Create a Launch Configuration for the t2.medium instance
resource "aws_launch_configuration" "t2medium" {
  name          = "t2medium-launch-configuration"
  image_id      = "ami-0b69ea66ff7391e80"  # Update this to a valid AMI ID for Mumbai region
  instance_type = "t2.medium"
  key_name      = "my-keypair"
  security_groups = [aws_security_group.allow_all.id]
}

# Create a Launch Configuration for the t2.micro instance
resource "aws_launch_configuration" "t2micro" {
  name          = "t2micro-launch-configuration"
  image_id      = "ami-0b69ea66ff7391e80"  # Update this to a valid AMI ID for Mumbai region
  instance_type = "t2.micro"
  key_name      = "my-keypair"
  security_groups = [aws_security_group.allow_all.id]
}

# Create an Auto Scaling Group for t2.micro instances
resource "aws_autoscaling_group" "asg_micro" {
  launch_configuration = aws_launch_configuration.t2micro.id
  min_size             = 1
  max_size             = 1
  desired_capacity     = 1
  vpc_zone_identifier  = [aws_subnet.main.id]
  tag {
    key                 = "Name"
    value               = "t2micro-instance"
    propagate_at_launch = true
  }
}

# Create an Auto Scaling Group for t2.medium instances
resource "aws_autoscaling_group" "asg_medium" {
  launch_configuration = aws_launch_configuration.t2medium.id
  min_size             = 1
  max_size             = 1
  desired_capacity     = 1
  vpc_zone_identifier  = [aws_subnet.main.id]
  tag {
    key                 = "Name"
    value               = "t2medium-instance"
    propagate_at_launch = true
  }
}

# Create an Application Load Balancer
resource "aws_lb" "app" {
  name               = "my-app-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_all.id]
  subnets            = [aws_subnet.main.id]
  enable_deletion_protection = false
  enable_cross_zone_load_balancing = true
  idle_timeout       = 60
  drop_invalid_header_fields = true
}

# Create a Listener for the Load Balancer
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "OK"
      status_code  = "200"
    }
  }
}

# Create a Target Group
resource "aws_lb_target_group" "target" {
  name     = "my-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# Create a Subnet
resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "main-subnet"
  }
}

# Create a Route Table
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main-gateway"
  }
}

# Associate Route Table with Subnet
resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

# Outputs
output "vpc_id" {
  value = aws_vpc.main.id
}

output "security_group_id" {
  value = aws_security_group.allow_all.id
}

output "load_balancer_arn" {
  value = aws_lb.app.arn
}
