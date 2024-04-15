resource "aws_security_group" "allow_tls" {
  name   = var.sgname # define this variable
  vpc_id = var.vpc_id # define this variable

  # Ingress rules
  dynamic "ingress" {
    for_each = var.port # define this variable
    content {
      description = "TLS from VPC"
      from_port   = ingress.value #ingress.value-gave value from (ingress) meaning dynamic block name and (value) taken from for_each = var.port   
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
    Name = var.sg-tag # define this variable
  }
}



#######################################variables
variable "sg-tag" {}
variable "sgname" {}
variable "vpc_id" {}
variable "port" {
  type    = list(number)
  default = [443, 80, 8080] # Example values, adjust as needed.
}
#################################################
######create new terraform.tfvars for below content
sg-tag = "Name=my-sg"
sgname = "sg"
vpc_id = "vpc-066da1176533784ff"





or  

resource "aws_security_group" "security-group" {
  vpc_id      = aws_vpc.vpc.id
  description = "Allowing Jenkins, Sonarqube, SSH Access"

  ingress = [
    for port in [22, 8080, 9000, 9090, 80] : {
      description      = "TLS from VPC"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      ipv6_cidr_blocks = ["::/0"]
      self             = false
      prefix_list_ids  = []
      security_groups  = []
      cidr_blocks      = ["0.0.0.0/0"]
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.sg-name
  }
}
















