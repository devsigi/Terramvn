module "modvars"{
    source = "../dirvars"
}

resource "aws_vpc" "resvpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "${module.modvars.env}_Vpc"
  }
}

resource "aws_internet_gateway" "resig" {
  vpc_id = aws_vpc.resvpc.id

  tags = {
    Name = "${module.modvars.env}_Ig"
  }
}

resource "aws_route_table" "resrtbl" {
  vpc_id = aws_vpc.resvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.resig.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id = aws_internet_gateway.resig.id
  }

  tags = {
    Name = "${module.modvars.env}_rtbl"
  }
}

variable "pubsubnets" {
  description = "Subnet CIDRs for public subnets (length must match configured availability_zones)"
  # this could be further simplified / computed using cidrsubnet() etc.
  # https://www.terraform.io/docs/configuration/interpolation.html#cidrsubnet-iprange-newbits-netnum-
  default = ["10.0.1.0/24", "10.0.3.0/24"]
  type = list
}

/*
variable "pvtsubnets" {
  description = "Subnet CIDRs for public subnets (length must match configured availability_zones)"
  # this could be further simplified / computed using cidrsubnet() etc.
  # https://www.terraform.io/docs/configuration/interpolation.html#cidrsubnet-iprange-newbits-netnum-
  default = ["10.0.2.0/24", "10.0.4.0/24"]
  type = "list"
} */

variable "azs" {
  description = "AZs in this region to use"
  default = ["us-east-1a", "us-east-1b"]
  type = list
}

resource "aws_subnet" "respubsubs" {
  count = "${length(var.pubsubnets)}"

#  default_subnet="true"
  vpc_id = "${aws_vpc.resvpc.id}"
  cidr_block = "${var.pubsubnets[count.index]}"
  availability_zone = "${var.azs[count.index]}"
  
  tags = {
    Name = "pubsub_${count.index}"
  }
  
}


/* resource "aws_default_subnet" "resdftsub" {
  availability_zone = "us-east-1a"

  tags = {
    Name = "Default subnet for us-east-1a"
  }
} */

resource "aws_route_table_association" "public" {
  count = "${length(var.pubsubnets)}"

  subnet_id      = "${element(aws_subnet.respubsubs.*.id, count.index)}"
  route_table_id = "${aws_route_table.resrtbl.id}"
}

resource "aws_security_group" "ressg" {
  name        = "${module.modvars.env}_sg"
  description = "sg for ec2 instance from module"
  vpc_id      = aws_vpc.resvpc.id

  ingress {
    description      = "SSH for VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["76.186.132.59/32"]
  }

  ingress {
    description      = "tcp for Jenkins"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["76.186.132.59/32"]
  }
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
#    ipv6_cidr_blocks = ["::/0"]
  }
}

output outsgid{
    value= "${aws_security_group.ressg.id}"
}

output outsubnet{
    value= "${aws_subnet.respubsubs[0].id}"
}


