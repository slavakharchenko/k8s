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

  self_managed_node_groups = {
    training_self_nodes = {
      name          = "training-self-mng"
      ami_id        = "ami-0db939bf834b05dd4"
      instance_type = "t2.medium"
      desired_size  = 2
      max_size      = 3
    }
  }

  # Self managed node groups will not automatically create the aws-auth configmap so we need to
  create_aws_auth_configmap = true
  manage_aws_auth_configmap = true

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