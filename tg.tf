resource "aws_lb_target_group" "alb_app_tg" {
  name        = "${var.COMPONENT}-${var.ENV}-tg"
  port        = var.APP_PORT
  protocol    = "HTTP"
  vpc_id      = data.terraform_remote_state.vpc.outputs.VPC_ID
}


resource "aws_lb_target_group_attachment" "attach_instances" {
  count            = var.OD_INSTANCE_COUNT + var.SPOT_INSTANCE_COUNT
  target_group_arn = aws_lb_target_group.alb-app-tg.arn
  target_id        = element(local.INSTANCE_IDS, count.index)
  port             = var.APP_PORT
}


