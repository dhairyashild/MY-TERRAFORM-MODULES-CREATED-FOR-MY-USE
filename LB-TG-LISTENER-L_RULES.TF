############         aws_lb            ############

resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [for subnet in aws_subnet.public : subnet.id]

  enable_deletion_protection = true
}


##########   Instance Target Group  ############

resource "aws_lb_target_group" "test" {
  name     = "tf-example-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}


###########    aws_lb_target_group_attachment       #########  tg & ec2  attached here

resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_lb_target_group.test.arn
  target_id        = aws_instance.test.id
  port             = 80
}


##########     aws_lb_listener     ##################   lb  & tg attached in listener resource like below

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.test.arn
  port              = "80"                             # replaced 443 to 80
  protocol          = "HTTP"                           # replaced HTTPS TO HTTP

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }
}
