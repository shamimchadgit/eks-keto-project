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
  hosted_zone_id        = module.bootstrap.hosted_zone_id
  eks_oidc_provider_arn = module.eks.oidc_provider_arn
  cluster_oidc_issuer_url = module.eks.cluster_oidc_issuer_url
}

module "bootstrap" {
    source = "../bootstrap"
}