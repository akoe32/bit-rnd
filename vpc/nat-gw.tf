# EIP nat staging-private
resource "aws_eip" "nat-staging-private-eip" {
  vpc = true

  tags = {
    Name        = "nat-staging-private-eip"
    Init        = "terraform"
    Project     = "koinworks"
    Environment = "development"
    Recipe      = "${var.IAC_REPO_BRANCH}"
  }
}
# NAT Gateway staging-private
resource "aws_nat_gateway" "nat-staging-private-natgw" {
  allocation_id = "${aws_eip.nat-staging-private-eip.id}"
  subnet_id     = "${aws_subnet.staging-public-subnet-a.id}"
  depends_on    = [aws_internet_gateway.main-staging-igw]

  tags = {
    Name    = "nat-staging-private-natgw"
    Init = "terraform"
    Recipe  = "${var.IAC_REPO_BRANCH}"
  }
}
