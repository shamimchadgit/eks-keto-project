variable "hosted_zone_arn" {
  type        = string
  description = "My hosted arn"
}

variable "eks_oidc_provider_arn" {
  type        = string
  description = "The ARN of my OIDC provider K8 module"
}

variable "cluster_oidc_issuer_url" {
    type = string
    description = "Kubernetes managed nodes module cluster oidc issuer url"
}