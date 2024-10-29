################################################################################
# Global
################################################################################
variable "project_name" {
  description = "A project name to be used in resources"
  type        = string
}

variable "environment" {
  description = " Dev, Prod, Staging or dynamic, will be used for tagging and naming of AWS Resources"
  type        = string
}

variable "account_id" {
  type        = string
  description = "AWS account number"
}

variable "region" {
  type        = string
  description = "The AWS region to deploy resources in"
}

################################################################################
# VPC
################################################################################
variable "vpc_params" {
  description = "VPC and subnets parameters"
  type = object({
    vpc_cidr               = string
    enable_nat_gateway     = bool
    single_nat_gateway     = bool
    one_nat_gateway_per_az = bool
    enable_flow_log        = bool
    private_bits           = number
    public_bits            = number
    intra_bits             = number
  })
}
