module "vpc" {
  source = "./modules/vpc"
}

module "eks" {
  source             = "./modules/eks"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  public_subnet_ids  = module.vpc.public_subnet_ids
}

module "external_dns" {
  source                = "./modules/external-dns"
  hosted_zone_arn        = data.terraform_remote_state.bootstrap.outputs.hosted_zone_arn
  eks_oidc_provider_arn = module.eks.oidc_provider_arn
  cluster_oidc_issuer_url = module.eks.cluster_oidc_issuer_url
}

data "terraform_remote_state" "bootstrap" {
    backend = "s3"

    config = {
      bucket = "eks-keto-tf-state-bucket"
      key = "bootstrap/terraform.tfstate"
      region = "eu-west-2"
    }
}