# Generate random string for unique bucket name
resource "random_string" "random_suffix" {
  length  = 5
  special = false
  upper   = false
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "basic-web-service-vpc-${random_string.random_suffix.result}"
  cidr = "10.0.0.0/16"

  azs             = ["${var.region}a", "${var.region}b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

# Security Group for ALB
resource "aws_security_group" "alb" {
  name        = "alb-sg-${random_string.random_suffix.result}"
  description = "Security group for ALB"
  vpc_id      = module.vpc.vpc_id

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

  tags = {
    Name = "alb-sg"
  }
}

# Security Group for EC2 instances
resource "aws_security_group" "ec2" {
  name        = "ec2-sg-${random_string.random_suffix.result}"
  description = "Security group for EC2 instances"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 8000
    to_port         = 8000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2-sg"
  }
}

# Launch Template
resource "aws_launch_template" "web" {
  name_prefix   = "web-template-${random_string.random_suffix.result}"
  image_id      = data.aws_ami.ubuntu_24_04.id
  instance_type = "t3.micro"

  network_interfaces {
    associate_public_ip_address = false
    security_groups            = [aws_security_group.ec2.id]
  }

  user_data = base64encode(<<-EOF
#!/bin/bash
cd ~ubuntu
sudo apt update
sudo apt install -y git python3-pip
git clone https://github.com/costnorm/example-env-iac.git
cd example-env-iac/basic_web_service/webapp_src
pip install -r requirements.txt --break-system-packages
nohup python3 main.py &
EOF
  )

  tags = {
    Name = "web-template"
  }
}

# Application Load Balancer
resource "aws_lb" "web" {
  name               = "web-alb-${random_string.random_suffix.result}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets           = module.vpc.public_subnets

  tags = {
    Name = "web-alb"
  }
}

# ALB Target Group
resource "aws_lb_target_group" "web" {
  name     = "web-target-group-${random_string.random_suffix.result}"
  port     = 8000
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    timeout             = 5
    path               = "/health"
    port               = "traffic-port"
    unhealthy_threshold = 2
  }
}

# ALB Listener
resource "aws_lb_listener" "web" {
  load_balancer_arn = aws_lb.web.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "web" {
  desired_capacity    = 2
  max_size           = 4
  min_size           = 1
  target_group_arns  = [aws_lb_target_group.web.arn]
  vpc_zone_identifier = module.vpc.private_subnets

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "web-asg-${random_string.random_suffix.result}"
    propagate_at_launch = true
  }

  depends_on = [ module.vpc ]
}