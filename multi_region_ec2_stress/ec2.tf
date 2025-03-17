module "ec2-seoul" {
  source = "./ec2_module"
  vpc_id = module.vpc-seoul.vpc_id
  subnet_id = module.vpc-seoul.public_subnets[0]
  cpu_utilization = 70
  ec2_profile_name = aws_iam_instance_profile.ec2_profile.name

  providers = {
    aws = aws.ap-northeast-2
  }
}

module "ec2-virginia" {
  source = "./ec2_module"
  vpc_id = module.vpc-virginia.vpc_id
  subnet_id = module.vpc-virginia.public_subnets[0]
  cpu_utilization = 55
  ec2_profile_name = aws_iam_instance_profile.ec2_profile.name

  providers = {
    aws = aws.us-east-1
  }
}

module "ec2-oregon" {
  source = "./ec2_module"
  vpc_id = module.vpc-oregon.vpc_id
  subnet_id = module.vpc-oregon.public_subnets[0]
  cpu_utilization = 30
  ec2_profile_name = aws_iam_instance_profile.ec2_profile.name

  providers = {
    aws = aws.us-west-2
  }
}
