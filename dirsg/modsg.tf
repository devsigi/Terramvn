module "modvars"{
    source = "../dirvars"
}

variable vpcid{}
variable sgid{}
#variable subnetid{}

/* variable "pubsubnets" {
  description = "Subnet CIDRs for public subnets (length must match configured availability_zones)"
  # this could be further simplified / computed using cidrsubnet() etc.
  # https://www.terraform.io/docs/configuration/interpolation.html#cidrsubnet-iprange-newbits-netnum-
  default = ["10.0.1.0/24", "10.0.3.0/24"]
  type = list
} 

variable "pvtsubnets" {
  description = "Subnet CIDRs for public subnets (length must match configured availability_zones)"
  # this could be further simplified / computed using cidrsubnet() etc.
  # https://www.terraform.io/docs/configuration/interpolation.html#cidrsubnet-iprange-newbits-netnum-
  default = ["10.0.2.0/24", "10.0.4.0/24"]
  type = list
} 

variable "azs" {
  description = "AZs in this region to use"
  default = ["us-east-1a", "us-east-1b"]
  type = list
}

resource "aws_subnet" "respvtsubs" {
  count = "${length(var.pvtsubnets)}"

#  default_subnet="true"
#  vpc_id = "${aws_vpc.resvpc.id}"
  vpc_id = "${var.vpcid}"
  cidr_block = "${var.pvtsubnets[count.index]}"
  availability_zone = "${var.azs[count.index]}"
  
  tags = {
    Name = "pvtsub_${count.index}"
  }
  
}

resource "aws_eip" "reseip" {
  vpc = true
  tags = {
    Name = "${module.modvars.env}_eip"
  }
}

resource "aws_nat_gateway" "resnat" {
#  connectivity_type = "public"
  allocation_id = aws_eip.reseip.id
  subnet_id         = "${var.subnetid}"
#  subnet_id         = aws_subnet.respubsubs[0].id
  tags = {
    Name = "${module.modvars.env}_nat"
  }
}	

resource "aws_route_table" "resrtblpvt" {
#  vpc_id = aws_vpc.resvpc.id
  vpc_id = var.vpcid

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.resnat.id
  } 

/*  route {
    ipv6_cidr_block = "::/0"
    gateway_id = aws_nat_gateway.resnat.id
  } */

/*  tags = {
    Name = "${module.modvars.env}_rtblpvt"
  }
}

resource "aws_route_table_association" "resrtasspvt" {
  count = "${length(var.pvtsubnets)}"

  subnet_id      = "${element(aws_subnet.respvtsubs.*.id, count.index)}"
  route_table_id = "${aws_route_table.resrtblpvt.id}"
}
*/
resource "aws_security_group" "ressgmvn" {
  name        = "${module.modvars.env}_mvnsg"
  description = "sg for mvn instances"
#  vpc_id      = aws_vpc.resvpc.id
  vpc_id      = var.vpcid

  ingress {
    description      = "SSH for VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups	 = ["${var.sgid}",]
#    security_groups = ["${aws_security_group.ressg.id}",]
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

output outsgmvnid{
    value= "${aws_security_group.ressgmvn.id}"
}
/*
output outsubnet{
    value= "${aws_subnet.respvtsubs[0].id}"
} */
