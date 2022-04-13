provider "aws" {
  region     = "us-east-1"
  profile = "default"
}

resource "aws_instance" "foo" {
  count=2      
  ami           = "ami-0c02fb55956c7d316"
  instance_type = var.x
  tags={
      Name="ec2 by TF_ ${count.index+1}"
  } 
  security_groups= ["sg1"]
  #key_name = "firstKey"
 user_data= file(var.userfile[count.index])  
}



resource "aws_security_group" "my-alb-sg" {
  name   = "my-alb-sg"
  vpc_id = aws_default_vpc.default.id
  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
   
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
   
  }
}
resource "aws_security_group" "sg" {
  name        = "sg1"
  description = "Allow TLS inbound traffic"
  

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    security_groups=["${aws_security_group.my-alb-sg.id}"]
    
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
 
  }
}



resource "aws_lb" "lb_first" {

  name               = "loadbalancerfirsttf"
  load_balancer_type = "application"
  security_groups = [
    "${aws_security_group.my-alb-sg.id}",
  ]
  #subnets = [for s in data.aws_subnet.example : s.id]
  subnets= [aws_default_subnet.default_az1.id,aws_default_subnet.default_az2.id]
}



resource "aws_lb_listener" "alb_forward_listener" {
  load_balancer_arn = aws_lb.lb_first.arn
  port = "80"
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.tcw_tg.arn
  }
}


resource "aws_lb_target_group_attachment" "test" {
  count=2
  target_group_arn = aws_lb_target_group.tcw_tg.arn
  target_id        = aws_instance.foo[count.index].id
  port             = 80
}

resource "aws_lb_target_group" "tcw_tg" {
   health_check {
    interval            = 10
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
name = "tcw-tg"
port = 80
protocol = "HTTP"
vpc_id = aws_default_vpc.default.id
target_type ="instance"
}


resource "aws_default_vpc" "default" {
  tags = {
    Name = "tcwvpc"
  }
}
resource "aws_default_subnet" "default_az1" {
  availability_zone = "us-east-1a"
  tags = {
    Name = "Default subnet for us-east-1"
  }
}
resource "aws_default_subnet" "default_az2" {
  availability_zone = "us-east-1b"
  tags = {
    Name = "Default subnet for us-east-1"
  }
}
