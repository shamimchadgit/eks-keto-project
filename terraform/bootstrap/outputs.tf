output "name_servers" {
    value = aws_route53_zone.eks_zone.name_servers
}