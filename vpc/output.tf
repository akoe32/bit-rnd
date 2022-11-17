output "staging-vpc-out" {
  value = "${aws_vpc.staging-vpc.id}"
}
output "private-staging-db-subnet-group-out" {
  value = "${aws_db_subnet_group.private-staging-db-subnet-group.id}"
}
output "public-staging-db-subnet-group-out" {
  value = "${aws_db_subnet_group.public-staging-db-subnet-group.id}"
}
output "staging-public-subnet-a-out" {
  value = "${aws_subnet.staging-public-subnet-a.id}"
}
output "staging-public-subnet-b-out" {
  value = "${aws_subnet.staging-public-subnet-b.id}"
}
output "staging-public-subnet-c-out" {
  value = "${aws_subnet.staging-public-subnet-c.id}"
}
output "sg-vpc-out"{
  value = "${aws_security_group.sg-vpc.id}"
}
