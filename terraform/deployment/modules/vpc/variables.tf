variable "cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnets_cidrs" {
  type        = list(string)
  description = "CIDR blocks for my 2 public subnets"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets_cidrs" {
  type        = list(string)
  description = "CIDR blocks for my 2 private subnets"
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

