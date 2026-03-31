resource "aws_iam_policy" "external_dns_policy" {
    name = "external-dns-policy"
    description = "To allow ExternalDNS to read zones and write records"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
        Effect = "Allow",
        Action = [
            "route53:ChangeResourceRecordSets",
            "route53:ListHostedZones",
            "route53:ListResourceRecordSets"
        ],
        Resource = var.hosted_zone_id
    }]
  })
}

data "aws_iam_openid_connect_provider" "oidc" {
    arn = var.eks_oidc_provider_arn
}

resource "aws_iam_role" "external_dns_role" {
    name = "external-dns-role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Effect = "Allow"
            Principal = {
                Federated = data.aws_iam_openid_connect_provider.oidc.arn
            }
            Action = "sts:AssumeRoleWithWebIdentity"
            Condition = {
                StringEquals = {
                    "${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}:sub" = "system:serviceaccount:external-dns:external-dns"
                }
            }
        }

        ]
    })
  
}

resource "aws_iam_role_policy_attachment" "external_dns_attach" {
    role = aws_iam_role.external_dns_role
    policy_arn = aws_iam_policy.external_dns_policy.arn
}