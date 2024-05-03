# Required variables

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
}

variable "primary_availability_zone" {
  description = "Primary availability zone"
}

variable "cidr" {
  description = "Base CIDR address for the VPC"
}


variable "region" {
  description = "AWS region"
}

# Optional variables

variable "name" {
  description = "Name of the VPC"
  default     = "main"
}

# For more information check out domain-name option in the AWS documentation for
# DHCP options: http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_DHCP_Options.html
variable "amazon_provided_dns" {
  description = "Amazon provided DNS suffix for region."

  default = {
    "us-east-1"      = "ec2.internal"
    "us-east-2"      = "us-east-2.compute.internal"
    "us-west-1"      = "us-west-1.compute.internal"
    "us-west-2"      = "us-west-2.compute.internal"
    "eu-west-1"      = "eu-west-1.compute.internal"
    "eu-central-1"   = "eu-central-1.compute.internal"
    "ap-northeast-1" = "ap-northeast-1.compute.internal"
    "ap-northeast-2" = "ap-northeast-2.compute.internal"
    "ap-southeast-1" = "ap-southeast-1.compute.internal"
    "ap-southeast-2" = "ap-southeast-2.compute.internal"
    "ap-south-1"     = "ap-south-1.compute.internal"
    "sa-east-1"      = "sa-east-1.compute.internal"
  }
}
