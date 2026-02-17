locals {
  image_tag = var.image_tag == "null" ? try(split(":", jsondecode(data.aws_ecs_task_definition.devops_task[0].container_definitions)[0].image)[1], "") : var.image_tag
}

output "image_tag" {
  value = local.image_tag
}
