output "name_servers" {
    value = aws_route53_zone.eks_zone.name_servers
}

output "hosted_zone_arn" {
    value = aws_route53_zone.eks_zone.arn
}