module "vpc" {
    source = "./modules/vpc"
    availability_zones = ["eu-central-1a", "eu-central-1b"]
    primary_availability_zone = "eu-central-1a"
    cidr = "10.1.0.0/16"
    region = "eu-central-1"
    name = "task1"
}