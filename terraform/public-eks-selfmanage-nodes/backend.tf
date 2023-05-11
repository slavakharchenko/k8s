terraform {
  backend "s3" {
    bucket = "training-tfstate-slavakharchenko"
    key    = "state/training-public-eks-selfmanage-nodes.state"
    region = "eu-central-1"
  }
}
