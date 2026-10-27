# terraform-aws-networking-jono
Networking module created during course

This module allows creation of vpc and subnets.  The subnets can be private or public

example:
```
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
  
```