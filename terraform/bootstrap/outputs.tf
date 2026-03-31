output "name_servers" {
    value = aws_route53_zone.eks_zone.name_servers
}

output "hosted_zone_id" {
    value = aws_route53_zone.eks_zone.zone_id
}