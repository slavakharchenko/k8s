module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "terraform-training-cluster"
  cluster_version = "1.25"

  cluster_endpoint_public_access = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id     = data.aws_vpc.default_vpc.id
  subnet_ids = data.aws_subnets.default_subnets.ids

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    disk_size = 50
  }

  eks_managed_node_groups = {
    general = {
      min_size     = 1
      desired_size = 1
      max_size     = 2

      instance_types = ["t2.medium"]
      capacity_type  = "ON_DEMAND"

      labels = {
        role = "general"
      }
    }
  }

  # aws-auth configmap
  manage_aws_auth_configmap = true

  ## TODO try to create role for eks admin
  #  aws_auth_roles = [
  #    {
  #      rolearn  = "arn:aws:iam::930050429294:policy/custom-eks-admin"
  #      username = "custom-eks-admin"
  #      groups   = ["system:masters"]
  #    },
  #  ]

  ## For root user if it necessary
  #  aws_auth_users = [
  #    {
  #      userarn  = "arn:aws:iam::930050429294:root"
  #      username = "root"
  #      groups   = ["system:masters"]
  #    },
  #  ]

  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::930050429294:user/viacheslav-user"
      username = "viacheslav-user"
      groups   = ["system:masters"]
    },
  ]

  tags = {
    Environment = "training"
    Terraform   = "true"
  }
}