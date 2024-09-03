# Syntx of variable

variable "example_var" {
  description = "An example input variable"
  type        = string
  default     = "default_value"
}

#example for variables

variable "AMI" {
    description = "image of the AMI"
    default = "ami-0c2af51e265bd5e0e" 
}

variable "micro" {
    description = "instance type of t2.micro"
    default = "t2.micro"
}

variable "medium" {
    description = "instance type of t2.medium"
    default = "t2.medium"
}

# funcation called 

resource "aws_instance" "app_server" {
  ami           = "${var.AMI}" // variable called from #11 line
  instance_type = "${var.medium}" // variable called from #21 line
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
