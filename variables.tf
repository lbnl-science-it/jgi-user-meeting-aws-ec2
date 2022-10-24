## AWS Region
variable "region" {
  type    = string
  default = "us-west-2"
}

## AWS EC2
variable "instance_type" {
  type = string
  ### 1-core cpu, 1-GB ram, ebs only,   $0.0116/hr
  #default = "t2.micro"
  ### 4-core cpu, 16-GB ram, 150-GB ssd, $0.206/hr
  #default = "m5ad.xlarge"
  ### 4-core cpu, 16-GB ram, 237-GB ssd, $0.206/hr
  #default = "m6id.xlarge"
  ### 4-core cpu, 8-GB ram, 150-GB nvme-ssd, $0.1736/hr
  #default = "c5ad.xlarge"
  ### 4-core cpu, 8-GB ram, 237-GB nvme-ssd, $0.2016/hr
  default = "c6id.xlarge"
}

variable "ami_id" {
  type = string
  ## ubuntu-20
  default = "ami-0aab355e1bfa1e72e"
  ## jgi-workshop AMI
  #default = "ami-0d56e02e63071e7f0"
  #default = "ami-0de8d8ed36f160e6a"

}
variable "security_group_name" {
  type    = string
  default = "jgi_security_group"
}
variable "instance_name" {
  type    = string
  default = "demo-eblast-workshop"
}
