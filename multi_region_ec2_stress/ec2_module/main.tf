resource "aws_security_group" "ec2_sg" {
  name = "ec2-sg"
  description = "Security group for EC2 instances"
  vpc_id = var.vpc_id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ec2_instance" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "m6g.medium"
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  subnet_id = var.subnet_id
  iam_instance_profile = var.ec2_profile_name
  tags = {
    Name = "stress-ec2-instance"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo su
              apt update
              apt install -y stress-ng
              
              # Calculate number of CPUs
              num_cpus=$(nproc)
              
              # Start stress-ng with specified CPU utilization
              stress-ng --cpu $num_cpus --cpu-load ${var.cpu_utilization} --timeout 0 &
              EOF
}