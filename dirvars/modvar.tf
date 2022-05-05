locals{
  worksc="${terraform.workspace}"
  
  env_list = {
    default="dev_mvn"
    dev="dev_mvn"
    prod="prod_mvn"
  }

  xenv = "${lookup(local.env_list, local.worksc)}"
}

output "env"{
  value = "${local.xenv}"
}
