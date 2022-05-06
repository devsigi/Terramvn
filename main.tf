provider "aws"{
    region = var.region

    access_key = var.accessKey
    secret_key = var.secretKey
#    profile = "aws cli profile id"	# which was set using aws config --profile
}

module "modsg" {
  vpcid = var.vpcid
#  sgid = var.sgid
#  subnetid = var.subnetid
  source = "./dirsg"
}

module "modec2"{
  sgid = "${module.modsg.outsgmvnid}"
  subnetid = var.subnetid
  amiid = var.amiid
  keyName = var.keyName
  source = "./direc2"
}

/* output pubip{
	value=module.modec2.pubip
} */
