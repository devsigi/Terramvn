provider "aws"{
    region = "us-east-1"

    access_key = var.accessKey
    secret_key = var.secretKey
#    profile = "aws cli profile id"	# which was set using aws config --profile
}

module "modsg" {
#  sg_name = "sg_${local.env}"
  source = "./dirsg"
}

module "modec2"{
  sgid = "${module.modsg.outsgid}"
  subnetid = "${module.modsg.outsubnet}"  
  amiid = var.amiid
  keyName = var.keyName
#  ec2_name = "EC2_${local.env}"
  source = "./direc2"
}

output pubip{
	value=module.modec2.pubip
}
