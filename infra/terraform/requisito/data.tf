data "aws_ecs_task_definition" "devops_task" {
  count           = var.image_tag == "cero" ? 1 : 0
  task_definition = "${var.service_name}-${var.env}"
}
