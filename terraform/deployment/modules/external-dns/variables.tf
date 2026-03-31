variable "hosted_zone_id" {
    type = string
    description = "My hosted zone id"
}

variable "eks_oidc_provider_arn" {
    type = string
    description = "The ARN of my OIDC provider K8 module"
}