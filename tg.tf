# Creates a target group
resource "aws_lb_target_group" "alb_app_tg" {
  name        = "${var.COMPONENT}-${var.ENV}-tg"
  port        = var.APP_PORT
  protocol    = "HTTP"
  vpc_id      = data.terraform_remote_state.vpc.outputs.VPC_ID
}

# Attaches the component instances to the component target group.
resource "aws_lb_target_group_attachment" "attach_instances" {
  count            = var.OD_INSTANCE_COUNT + var.SPOT_INSTANCE_COUNT
  target_group_arn = aws_lb_target_group.alb_app_tg.arn
  target_id        = element(local.INSTANCE_IDS, count.index)
  port             = var.APP_PORT
}


resource "aws_lb_listener_rule" "app_rule" {
#   count        =  var.LB_TYPE == "internal" ? 1 : 0

  listener_arn = data.terraform_remote_state.alb.outputs.PRIVATE_LISTENER_ARN
  priority     = random_integer.priority.result

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_app_tg.arn
  }

  condition {
    host_header {
      values = ["${var.COMPONENT}-${var.ENV}.${data.terraform_remote_state.vpc.outputs.PRIVATE_HOSTED_ZONE_NAME}"]
    }
  }
}

# Generates a random integar
resource "random_integer" "priority" {
  min = 1
  max = 50000
}

#
# resource "aws_lb_listener" "public" {
#   load_balancer_arn = data.terraform_remote_state.alb.outputs.PUBLIC_ALB_ARN
#   port              = 80
#   protocol          = "HTTPS"
 
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.alb_app_tg.arn
#   }
# }

