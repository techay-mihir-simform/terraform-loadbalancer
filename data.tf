/*data "aws_vpc" "vpc_available" {
  filter {
    name   = "tag:Name"
    values = ["tcwvpc"]
  }
}*/

/*
data "aws_instance" "ec2_my_admin_instance" {
    count=1
  filter {
    name = "tag:Name"
    values = ["ec2 by TF_ ${count.index+1}"]
  }
}*/

/*data "aws_subnet_ids" "selected" {
  vpc_id=aws_default_vpc.default.id
}*/


/*data "aws_subnet_ids" "example" {
  vpc_id = aws_default_vpc.default.id
}

data "aws_subnet" "example" {
  for_each = toset(data.aws_subnet_ids.example.ids)
  id       = each.value
}*/
/*
data "aws_subnets" "example" {
  filter {
    name   = "vpc-id"
    values = [aws_default_vpc.default.id]
  }
}


data "aws_subnet" "example" {
  for_each = toset(data.aws_subnets.example.ids)
  id       = each.value
}
*/