module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.0"

  name = "devops-vpc-${var.env}"
  cidr = "10.0.0.0/16"

  azs                = [format("%sa", var.aws_region), format("%sb", var.aws_region)]
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets    = ["10.0.3.0/24", "10.0.4.0/24"]
  enable_nat_gateway = true
}
