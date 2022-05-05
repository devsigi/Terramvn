locals{
  worksc="${terraform.workspace}"
  
  env_list = {
    default="dev_env"
    dev="dev_env"
    prod="prod_env"
  }

  xenv = "${lookup(local.env_list, local.worksc)}"
}

output "env"{
  value = "${local.xenv}"
}
