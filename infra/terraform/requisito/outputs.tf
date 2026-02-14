output "ecr_repository_url" {
  value = aws_ecr_repository.devops_repo.repository_url
}

output "alb_dns_name" {
  value = aws_lb.devops_alb.dns_name
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.devops_cluster.name
}
