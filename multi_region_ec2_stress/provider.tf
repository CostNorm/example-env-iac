provider "aws" {
  region = "us-east-1"
  profile = var.awscli_profile
}

provider "aws" {
  region = "us-east-1"
  profile = var.awscli_profile
  alias = "us-east-1"
}

provider "aws" {
  region = "us-west-2"
  profile = var.awscli_profile
  alias = "us-west-2"
}

provider "aws" {
  region = "ap-northeast-2"
  profile = var.awscli_profile
  alias = "ap-northeast-2"
}