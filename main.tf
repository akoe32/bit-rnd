module "vpc" {
  source = "./vpc"
}

module "iam" {
  source = "./iam"
}

module "iam-role" {
  source = "./iam/role"
}

module "keys" {
  source = "./keys"
}

module "ec2" {
  source = "./ec2"
}

module "rds" {
  source = "./rds"
}