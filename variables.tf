# variable "vpc_cidr" {
#   type = string

#   validation {
#     condition     = can(cidrnetmask(var.vpc_cidr))
#     error_message = "The variable vpc_cidr must be valid CIDR"
#   }
# }

# variable "vpc_name"{
#   type = string
# }


variable "vpc_config" {
  description = "The VPC cidr_block and name of the VPC to be created"
  type = object({
    cidr_block = string
    name       = string
  })

  validation {
    condition     = can(cidrnetmask(var.vpc_config.cidr_block))
    error_message = "The variable vpc_cidr must be valid CIDR"
  }

}

variable "subnet_config" {
  description = <<EOT
  Accepts a map of the subnet config.  Each subnet should have:
  cidr_block: The CIDR block of the subnet
  az: The az of the subnet

  Optionally:
  public: true, if this subnet is to be a public subnet.  Default is private subnet.
  EOT
  type = map(object({
    cidr_block = string
    public     = optional(bool, false)
    az         = string
  }))
  validation {
    condition = alltrue([
      for config in values(var.subnet_config) :
    can(cidrnetmask(config.cidr_block))])
    error_message = "The variable subnet_config.vpc_cidr must be valid CIDR"
  }
}