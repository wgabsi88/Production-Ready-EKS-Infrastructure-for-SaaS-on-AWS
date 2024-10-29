data "aws_availability_zones" "available" {
  state = "available"
}
data "aws_caller_identity" "current" {}


locals {
  project_name = "${var.project_name}-${var.environment}"
  azs          = slice(data.aws_availability_zones.available.names, 0, 3)
  tags = {
    project_name = var.project_name
    environment  = var.environment
    admin        = data.aws_caller_identity.current.arn
  }
}


module "vpc" {
  source          = "terraform-aws-modules/vpc/aws"
  version         = "~> 5.14.0"
  name            = local.project_name
  tags            = local.tags
  cidr            = var.vpc_params.vpc_cidr
  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(var.vpc_params.vpc_cidr, var.vpc_params.private_bits, k)]
  private_subnet_tags = {

    "kubernetes.io/role/internal-elb" = 1

  }
  public_subnets = [for k, v in local.azs : cidrsubnet(var.vpc_params.vpc_cidr, var.vpc_params.public_bits, k + 48)]
  public_subnet_tags = {

    "kubernetes.io/role/elb" = 1

  }
  intra_subnets          = [for k, v in local.azs : cidrsubnet(var.vpc_params.vpc_cidr, var.vpc_params.intra_bits, k + 64)]
  enable_nat_gateway     = var.vpc_params.enable_nat_gateway
  single_nat_gateway     = var.vpc_params.single_nat_gateway
  one_nat_gateway_per_az = var.vpc_params.one_nat_gateway_per_az
  enable_flow_log        = var.vpc_params.enable_flow_log
}

module "endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "~> 5.14.0"

  vpc_id = module.vpc.vpc_id

  create_security_group = true

  security_group_description = "VPC endpoint security group"
  security_group_rules = {
    ingress_https = {
      description = "HTTPS from VPC"
      cidr_blocks = [module.vpc.vpc_cidr_block]
    }
  }

  endpoints = {
    s3 = {
      service         = "s3"
      service_type    = "Gateway"
      route_table_ids = flatten([module.vpc.intra_route_table_ids, module.vpc.private_route_table_ids, module.vpc.public_route_table_ids])
      tags            = { Name = "${local.project_name}-vpc-ep-s3" }
      policy          = data.aws_iam_policy_document.generic_endpoint_policy.json
    },
    dynamodb = {
      service         = "dynamodb"
      service_type    = "Gateway"
      route_table_ids = flatten([module.vpc.intra_route_table_ids, module.vpc.private_route_table_ids, module.vpc.public_route_table_ids])
      tags            = { Name = "${local.project_name}-vpc-ep-ddb" }
      policy          = data.aws_iam_policy_document.generic_endpoint_policy.json
    },
    sts = {
      service             = "sts"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
      tags                = { Name = "${local.project_name}-vpc-ep-sts" }
      policy              = data.aws_iam_policy_document.generic_endpoint_policy.json

    },
    ecr_api = {
      service             = "ecr.api"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
      tags                = { Name = "${local.project_name}-vpc-ep-ecr-api" }
      policy              = data.aws_iam_policy_document.generic_endpoint_policy.json

    },
    ecr_dkr = {
      service             = "ecr.dkr"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
      tags                = { Name = "${local.project_name}-vpc-ep-ecr-dkr" }
      policy              = data.aws_iam_policy_document.generic_endpoint_policy.json

    }
  }
}


data "aws_iam_policy_document" "generic_endpoint_policy" {
  statement {
    effect    = "Deny"
    actions   = ["*"]
    resources = ["*"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "StringNotEquals"
      variable = "aws:SourceVpc"

      values = [module.vpc.vpc_id]
    }
  }
}
