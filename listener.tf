resource "aws_lb_listener" "app_listener" {
  count             =  var.LB_TYPE == "internal" ? 1 : 0
  load_balancer_arn = data.terraform_remote_state.alb.PRIVATE_ALB_ARN
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code  = "200"
    }
  }
}


resource "aws_lb_listener_rule" "app_rule" {
  listener_arn = aws_lb_listener.app_listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_app_tg.arn
  }
  condition {
    host_header {
      values = ["example.com"]
    }
  }
}



