module "vpc" {
  source = "./vpc"
}

module "ec2" {
  source = "./ec2"
}

module "rds" {
  source = "./rds"
}