provider "aws" {
region = "ap-south-1"
}

# Locals for reusable values
locals {
  name = "eks-healthcare-cluster"          
  vpc_cidr_block  = "10.0.0.0/16"             # VPC CIDR block
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]  # Public subnets
  private_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"] # Private subnets
  azs             = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]  # Availability zones in ap-south-1
}
