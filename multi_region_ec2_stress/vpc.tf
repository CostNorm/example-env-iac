module "vpc-seoul" {
  source = "terraform-aws-modules/vpc/aws"

  name = "stress-vpc-seoul"
  cidr = "10.0.0.0/16"

  azs             = ["ap-northeast-2a"]
  public_subnets  = ["10.0.101.0/24"]

  map_public_ip_on_launch = true

  providers = {
    aws = aws.ap-northeast-2
  }
}

module "vpc-virginia" {
  source = "terraform-aws-modules/vpc/aws"

  name = "stress-vpc-virginia"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a"]
  public_subnets  = ["10.0.101.0/24"]

  map_public_ip_on_launch = true

  providers = {
    aws = aws.us-east-1
  }
}

module "vpc-oregon" {
  source = "terraform-aws-modules/vpc/aws"

  name = "stress-vpc-oregon"
  cidr = "10.0.0.0/16"

  azs             = ["us-west-2a"]
  public_subnets  = ["10.0.101.0/24"]

  map_public_ip_on_launch = true

  providers = {
    aws = aws.us-west-2
  }
}