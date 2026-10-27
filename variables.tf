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