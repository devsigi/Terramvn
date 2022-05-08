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

/* data "template_file" "user_data" {
  template = file("userdata.yaml")
} */

resource "aws_instance" "resec2mvn" {
  ami           	= "${var.amiid}"
  instance_type 	= "t2.micro"
  availability_zone = "us-east-1a"
  key_name 		= var.keyName
  vpc_security_group_ids = ["${var.sgid}"]
  subnet_id 		= var.subnetid
  associate_public_ip_address = "true"

#  user_data 		= data.template_file.user_data.rendered
  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = file("${var.keyName}.pem")
    host = self.public_ip
  } 
/*  provisioner "local-exec" {
  	command = "sleep 60; ssh -i ${var.keyName}.pem ec2-user@${aws_instance.resec2mvn.private_ip} 'echo hello from hostname'"
}	*/
# upload chef cookbooks and repo content 
  # Copy in the bash script we want to execute.
  # The source is the location of the bash script
  # on the local linux box you are executing terraform
  # from.  The destination is on the new AWS instance.
  provisioner "file" {
    source      = "userdata/"
    destination = "/tmp"
  }
  # Change permissions on bash script and execute from ec2-user.
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/userdata.sh",
      "chmod +x /tmp/setpath.sh",
      "sudo /tmp/userdata.sh",
    ]
  } 

  tags = {
    Name = "${module.modvars.env}_mvn"
  }
}
