# terraform {
#   backend "s3" {
#     bucket         = "saas-infrastructure-on-aws-with-eks"
#     key            = "dev/saas.tfstate"
#     region         = "eu-central-1"
#     dynamodb_table = "saas-infrastructure-on-aws-with-eks-lock"
#     encrypt        = true
#   }
# }
