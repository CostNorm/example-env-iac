# ubuntu 24.04 ami data source
data "aws_ami" "ubuntu_24_04" {
  most_recent = true
  owners      = ["099720109487"]
  name_regex  = "^ubuntu/images/hvm-ssd-gp3/ubuntu-jammy-24.04-amd64-server-*"
}
