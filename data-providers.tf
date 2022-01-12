data "aws_subnet_ids" "default_subnets" {
  vpc_id = aws_default_vpc.default.id
}

data "aws_ami" "aws_linux_2_latest" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm*"]
  }
  #It's good practice to filter by the architecture but It's not needed, it takes the x86_64 by default
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}