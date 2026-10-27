module "jsnetworking" {
  source = "./modules/networking"
  # vpc_cidr="10.0.0.0/16"
  # vpc_name = "jonovpc3"
  vpc_config = {
    cidr_block = "10.0.0.0/16"
    name       = "sdfsdf"
  }
  subnet_config = {
    subnet_1 = {
      cidr_block = "10.0.1.0/24"
      az         = "ap-southeast-2a"
    }
    subnet_2 = {
      cidr_block = "10.0.2.0/24"
      public     = true
      az         = "ap-southeast-2b"
    }
  }
}

output "module_public_subnets" {
  # we needed this as the outputs in modules will not be seen in plan
  value = module.jsnetworking.public_subnets
}

output "module_vpc" {
    value=module.jsnetworking.vpc_id
}


output "module_private_subnets" {
  # we needed this as the outputs in modules will not be seen in plan
  value = module.jsnetworking.private_subnets
}

output "subnet_ids" {
    value=module.jsnetworking.subnets
}

output "output_public_subnets" {
    value=module.jsnetworking.output_public_subnets
}

output "output_private_subnets" {
    value=module.jsnetworking.output_private_subnets
}