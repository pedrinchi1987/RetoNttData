data "aws_ecs_task_definition" "devops_task" {
  count           = var.image_tag == "null" ? 1 : 0
  task_definition = "${var.service_name}-${var.env}"
}

output "devops_task" {
  value = try(data.aws_ecs_task_definition.devops_task[0].container_definitions, "NO DATA")
}

output "devops_task2" {
  value = try(jsondecode(data.aws_ecs_task_definition.devops_task[0].container_definitions)[0].image, "ERROR")
}

