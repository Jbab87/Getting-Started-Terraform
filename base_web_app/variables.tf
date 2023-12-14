variable "aws_access_key" {
  type        = string
  description = "AWS Access Key"
  sensitive   = true
}

variable "aws_secret_key" {
  type        = string
  description = "AWS Secret Key"
  sensitive   = true

}

variable "aws_region" {
  type        = string
  description = "AWS region to use for resources"
  default     = "us-east-1"

}


variable "aws_vpc_cdir_block" {
  type        = string
  description = "Base CIDR Block for VPC"
  default     = "10.0.0.0/16"

}

variable "aws_vpc_public_subnets_cdir_block" {
  type        = list(string)
  description = "CIDR Blocks for Public Subnets in VPC"
  default     = ["10.0.0.0/24", "10.0.0.0./24"]

}

variable "aws_vpc_enable_dns_hostnames_value" {
  type        = bool
  description = "Enable DNS hostnames in VPC"
  default     = true
}

variable "map_public_ip_on_launch_bool_val" {
  type        = bool
  description = "Map a public IP address for Subnet instances"
  default     = true

}

variable "aws_instance_type" {
  type        = string
  description = "Type for EC2 Instance"
  default     = "t3.micro"

}

variable "company" {
  type        = string
  description = "Company name for resource tagging"
  default     = "Globomantics"


}

variable "project" {
  type        = string
  description = "Project name for resource tagging"

}

variable "billing_code" {
  type        = string
  description = "Billing code for resource tagging"

}