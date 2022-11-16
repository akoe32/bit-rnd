variable "AWS_REGION" {
  default = "ap-southeast-1"
}

variable "AWS_ID" {
  default = "302091057835"
}

variable "IAC_REPO_BRANCH" {
  default = "devops-iac:master"
}

variable "EC2_INSTANCE_NAME"{
  default = "apps-instance"
}

variable "EC2_ENV"{
  default = "staging"
}

variable "EC2_VOLUME_SIZE"{
  type = number
  default = "80"
}
variable "EC2_KEY_NAME"{
    default ="devops"
}
variable APPS_DB_HOST{
    default = "10.0.0.1"
}
variable APPS_DB_PASS{
    default = "toor123"
}
variable APPS_DB_NAME{
    default= "postgres"
}
variable APPS_DB_USER{
    default = "postgres"
}
variable APPS_DB_PORT{
    default = "5432"
}
variable APPS_OWM_API_KEY{
    default = "coba"
}
variable APPS_OWM_LOCATION{
    default = "jakarta"
}
variable APPS_OWM_UNITS{
    default = "metric"
}
variable "EC2_AMI" {
  type = map
  default = {
    "ap-southeast-1" = "ami-0ff297662c4840aa5"
    "ap-southeast-2" = "ami-0009ba887e00637bd"
  }
}
variable "staging-public-subnet-a" {
}