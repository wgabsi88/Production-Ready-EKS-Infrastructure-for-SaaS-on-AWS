output "vpc_cidr" {
  value = var.vpc_params.vpc_cidr
}

output "vpc_public_subnets" {
  value = module.vpc.public_subnets_cidr_blocks
}

output "vpc_private_subnets" {
  value = module.vpc.private_subnets_cidr_blocks
}

output "vpc_intra_subnets" {
  value = module.vpc.intra_subnets_cidr_blocks
}
