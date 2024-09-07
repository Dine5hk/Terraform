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


variable "prometheus" {
  description = "Script to install Prometheus and its components"
  default = <<EOF
#!/bin/bash
mkdir -p /home/ubuntu/prometheus
cd /home/ubuntu/prometheus
wget https://github.com/prometheus/prometheus/releases/download/v2.54.1/prometheus-2.54.1.linux-amd64.tar.gz
wget https://github.com/prometheus/alertmanager/releases/download/v0.27.0/alertmanager-0.27.0.linux-amd64.tar.gz
wget https://github.com/prometheus/blackbox_exporter/releases/download/v0.25.0/blackbox_exporter-0.25.0.linux-amd64.tar.gz
wget https://github.com/prometheus/node_exporter/releases/download/v1.8.2/node_exporter-1.8.2.linux-amd64.tar.gz
tar -xvf prometheus-2.54.1.linux-amd64.tar.gz
tar -xvf alertmanager-0.27.0.linux-amd64.tar.gz
tar -xvf blackbox_exporter-0.25.0.linux-amd64.tar.gz
tar -xvf node_exporter-1.8.2.linux-amd64.tar.gz
mv prometheus-2.54.1.linux-amd64 prometheus
mv alertmanager-0.27.0.linux-amd64 alertmanager
mv blackbox_exporter-0.25.0.linux-amd64 blackbox_exporter
mv node_exporter-1.8.2.linux-amd64 node_exporter
rm *.tar.gz
EOF
}


# Define a variable for the Grafana setup script
variable "grafana" {
  description = "Script to pull and run Grafana Docker container"
  default = <<EOF
docker pull grafana/grafana
docker run -d -p 3000:3000 --name=grafana -v grafana-data:/var/lib/grafana grafana/grafana
EOF
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

resource "aws_instance" "app_server" {
  ami           = "ami-0c2af51e265bd5e0e"
  instance_type = "t2.medium"
  count         = 2
  key_name      = "terraform"
  vpc_security_group_ids = [aws_security_group.terraform.id]
  user_data = <<EOF
  #!/bin/bash
  sudo apt-get update -y
  sudo apt-get install -y docker.io
  sudo systemctl start docker
  sudo systemctl enable docker
  ${var.grafana}
  ${var.prometheus}
  EOF
}
