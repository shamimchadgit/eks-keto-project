output "external_dns_role_arn" {
  value = aws_iam_role.external_dns_role.arn
  description = "Output arn for external dns role so K8 service a/c can assume role"
}

# gives permissions directly to POD (IRSA)