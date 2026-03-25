variable "vpc_id" {
  type        = string
  description = "ID for my VPC"
}

variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
  default     = "eks-keto-cluster"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet worker nodes will run in"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "Public subnet control plane will run in"
}