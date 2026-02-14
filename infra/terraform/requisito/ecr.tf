resource "aws_ecr_repository" "devops_repo" {
  name                 = "${var.service_name}-${var.env}"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}
