variable "x"{
    default= "t2.micro"
    type = string
}
variable "y"{
    default= "file1.sh"
    type = string
}

variable "userfile"{
    type=list(string)
    default = ["file1.sh","file2.sh"]
}
output "o1"{
  
    value = aws_default_subnet.default_az1.id
}
output "o2"{
  
    value = aws_default_subnet.default_az2.id
}
/*
output "subnet_id" {
  value = [for s in data.aws_subnet.example : s.id]
}*/