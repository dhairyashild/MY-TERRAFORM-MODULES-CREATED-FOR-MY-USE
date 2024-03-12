resource "aws_security_group" "allow_tls" {
  name   = var.sgname            # define this variable
  vpc_id = var.vpc_id           # define this variable

  # Ingress rules
  dynamic "ingress" {
    for_each = var.port           # define this variable
    content {
      description = "TLS from VPC"
      from_port   = ingress.value   #ingress.value-gave value from (ingress) meaning dynamic block name and (value) taken from for_each = var.port   
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  # Egress rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "var.sg-tag"              # define this variable
  }
}
