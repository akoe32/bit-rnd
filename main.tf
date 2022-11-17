module "vpc" {
  source = "./vpc"

}

module "ec2" {
  source = "./ec2"
#  sg-vpc = "${module.vpc.sg-vpc-out}"
}

module "rds" {
  source = "./rds"
#  sg-vpc = "${module.vpc.sg-vpc-out}"
}
