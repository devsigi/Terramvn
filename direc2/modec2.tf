/* variable amiid{
  default= "ami-0022f774911c1d690"
} */

module "modvars"{
    source = "../dirvars"
}

variable "sgid" {}
variable "subnetid" {}
variable "amiid"{}
variable "keyName"{}

resource "aws_instance" "resec2jen" {
  ami           	= "${var.amiid}"
  instance_type 	= "t2.micro"
  availability_zone = "us-east-1a"
  key_name 		= var.keyName
  vpc_security_group_ids = ["${var.sgid}"] 
  subnet_id 		= var.subnetid
  associate_public_ip_address = "true"

  #user_data 		= file("userdata.sh")
  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = file("Jenser.pem")
    host = self.public_ip
  }
  
  # Copy in the bash script we want to execute.
  # The source is the location of the bash script
  # on the local linux box you are executing terraform
  # from.  The destination is on the new AWS instance.
  provisioner "file" {
    source      = "userdata.sh"
    destination = "/tmp/userdata.sh"
  }
  # Change permissions on bash script and execute from ec2-user.
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/userdata.sh",
      "sudo /tmp/userdata.sh",
    ]
  }

  tags = {
    Name = "${module.modvars.env}_EC2"
  }
}

output "pubip"{
	value = "${formatlist("http://%s:%s/", aws_instance.resec2jen.*.public_ip, "8080")}"
}
