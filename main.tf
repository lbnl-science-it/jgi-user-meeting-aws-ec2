################################################
## Define the provider
################################################
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.11.0"
    }
  }
}
################################################


################################################
## Module Provider Alias
################################################
provider "aws" {
  # assume_role {
  #   role_arn = "arn:aws:iam::${var.account_id}:role/OrganizationAccountAccessRole"
  # }
  alias  = "ROOT_0"
  region = var.region
}
################################################


################################################
### Create EC2
################################################
module "root_0_ec2_0" {
  source              = "./modules/ec2_instance"
  instance_name       = var.instance_name
  instance_type       = var.instance_type
  ami_id              = var.ami_id
  security_group_name = var.security_group_name
  ec2_region          = var.region
  #key_id 	      = var.key_id
  #access_key 	      = var.access_key
  #s3name	      = var.s3name
  providers = { aws = aws.ROOT_0 }
}
################################################


################################################
### Output resource details
################################################
output "RESOURCE_DETAILS" {
  value = [
    { "EC2_INSTANCES" = module.root_0_ec2_0.ec2_summary }
  ]
}
################################################
