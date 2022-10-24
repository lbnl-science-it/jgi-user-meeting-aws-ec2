variable "instance_name" {
  type    = string
  default = "ExampleServerInstance"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ami_id" {
  type    = string
  default = "ami-0aab355e1bfa1e72e"
}

variable "ec2_region" {
  type    = string
  default = "us-west-2"
}

variable "security_group_name" {
  type    = string
  default = "sshSecurityGroup"
}

variable "key_id" {
  type    = string
  default = "your_public_key"
}

variable "access_key" {
  type    = string
  default = "your_secret_key"
}

variable "github_token" {
  type    = string
  default = "your_github_token"
}

variable "s3name" {
  type    = string
  default = "your_s3_name"
}