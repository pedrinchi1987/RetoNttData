data "aws_ecs_task_definition" "devops_task" {
  #count    = var.image_tag=="null"?1:0
  task_definition = "${var.service_name}-${var.env}"
}

output "devops_task" {
  value = data.aws_ecs_task_definition.devops_task
}
