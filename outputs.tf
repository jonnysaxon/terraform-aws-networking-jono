locals {
    output_public_subnets = {
        # keys(local.public_subnets) = keys["subnet_2"]
        # e.g. for key in ["subnet_2"]: keyj => "hello"
        # would give the map {
        # subnet_2 ="hello"
        #}
        for key, config in local.public_subnets : key => {
        #for key in keys(local.public_subnets) : key => {
            subnet_id=aws_subnet.this[key].id
            #aws_subnet.this["subnet_2"].id
            az=aws_subnet.this[key].availability_zone
            cidr_block=config.cidr_block
        }
    }

    output_private_subnets = {
        # keys(local.public_subnets) = keys["subnet_2"]
        # e.g. for key in ["subnet_2"]: keyj => "hello"
        # would give the map {
        # subnet_2 ="hello"
        #}
        # for key, config in local.private_subnets: key => { <--- this line could be written like this, but because we never access config, we can leave it out
        for key in keys(local.private_subnets) : key => {
            subnet_id=aws_subnet.this[key].id
            #aws_subnet.this["subnet_2"].id
            az=aws_subnet.this[key].availability_zone
            
        }
    }
}
# output "public_subnets" {
#   value = local.public_subnets
# }

output "vpc_id" {
    value=aws_vpc.this.id
}

# output "private_subnets"{
#    value = local.private_subnets

# }

output "public_subnets" {
    value=local.output_public_subnets
}

output "private_subnets" {
    value=local.output_private_subnets
}