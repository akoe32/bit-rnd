terraform {
  backend "s3" {
    bucket	= "bit-rnd-5171"
    key		  = "tfstate/terraform.tfstate"
    region	= "ap-southeast-1"
  }
}
