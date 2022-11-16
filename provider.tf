provider "aws" {
  access_key = "${var.AWS_ACCESS_KEY}"
  secret_key = "${var.AWS_SECRET_KEY}"
  region = "ap-southeast-1"
  skip_region_validation = true
#  assume_role {
#    role_arn = "arn:aws:iam::715265456386:role/devops-admin"
#   }
  

}