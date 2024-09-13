# VPC Module
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.18.1"

  name                 = "my-vpc"
  cidr                 = local.vpc_cidr_block
  azs                  = local.azs
  public_subnets       = local.public_subnets
  private_subnets      = local.private_subnets
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
}

# EKS Module
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "18.29.0"

  cluster_name    = local.name
  cluster_version = "1.24"  # Specify the Kubernetes version
  subnets         = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id

  node_groups = {
    eks_nodes = {
      desired_capacity = 2
      max_capacity     = 2
      min_capacity     = 1

      instance_type = "t3.medium"
    }
  }

  enable_irsa = true  # Enable IAM Roles for Service Accounts (IRSA)
}

# Direct Outputs (Embedded in main.tf)
output "eks_cluster_name" {
  value = module.eks.cluster_id
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

