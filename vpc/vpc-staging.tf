# VPC id
resource "aws_vpc" "staging-vpc" {
  cidr_block           = "172.16.0.0/16"
  enable_dns_hostnames = "true"

  tags = {
    Environment   = "staging"
    Name    = "staging-vpc"
    Init = "terraform"
    Billing = "communication"
    Recipe  = "${var.IAC_REPO_BRANCH}"
  }
}

## Subnet ###
## Private Subnet
resource "aws_subnet" "staging-private-subnet-a" {
  vpc_id            = "${aws_vpc.staging-vpc.id}"
  cidr_block        = "172.16.1.0/24"
  availability_zone = "${lookup(var.AWS_AZ_A, var.AWS_REGION)}"

  tags = {
    Name    = "staging-private-subnet-a"
    Init = "terraform"
    Recipe  = "${var.IAC_REPO_BRANCH}"
  }
}
resource "aws_subnet" "staging-private-subnet-b" {
  vpc_id            = "${aws_vpc.staging-vpc.id}"
  cidr_block        = "172.16.2.0/24"
  availability_zone = "${lookup(var.AWS_AZ_B, var.AWS_REGION)}"

  tags = {
    Name    = "staging-private-subnet-b"
    Init = "terraform"
    Recipe  = "${var.IAC_REPO_BRANCH}"
  }
}
resource "aws_subnet" "staging-private-subnet-c" {
  vpc_id            = "${aws_vpc.staging-vpc.id}"
  cidr_block        = "172.16.3.0/24"
  availability_zone = "${lookup(var.AWS_AZ_C, var.AWS_REGION)}"

  tags = {
    Name    = "staging-private-subnet-c"
    Init = "terraform"
    Recipe  = "${var.IAC_REPO_BRANCH}"
  }
}

# Route tables
resource "aws_route_table" "staging-private-rtb" {
  vpc_id = "${aws_vpc.staging-vpc.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.main-nat-staging-private-natgw.id}"
  }
  route {
    cidr_block = "172.19.0.0/16"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.middleware-to-staging-vpc.id}"
  }

  tags = {
    Name    = "staging-private-rtb"
    Init = "terraform"
    Recipe  = "${var.IAC_REPO_BRANCH}"
  }
}

# Route tables association to  private Subnets
resource "aws_route_table_association" "staging-private-rtb-assoc-a" {
  subnet_id      = "${aws_subnet.staging-private-subnet-a.id}"
  route_table_id = "${aws_route_table.staging-private-rtb.id}"
}
resource "aws_route_table_association" "staging-private-rtb-assoc-b" {
  subnet_id      = "${aws_subnet.staging-private-subnet-b.id}"
  route_table_id = "${aws_route_table.staging-private-rtb.id}"
}
resource "aws_route_table_association" "staging-private-rtb-assoc-c" {
  subnet_id      = "${aws_subnet.staging-private-subnet-c.id}"
  route_table_id = "${aws_route_table.staging-private-rtb.id}"
}


## Public Subnet
resource "aws_subnet" "staging-public-subnet-a" {
  vpc_id            = "${aws_vpc.staging-vpc.id}"
  cidr_block        = "172.16.5.0/24"
  availability_zone = "${lookup(var.AWS_AZ_A, var.AWS_REGION)}"
  map_public_ip_on_launch = true

  tags = {
    Name    = "staging-public-subnet-a"
    Init = "terraform"
    Recipe  = "${var.IAC_REPO_BRANCH}"
  }
}
resource "aws_subnet" "staging-public-subnet-b" {
  vpc_id            = "${aws_vpc.staging-vpc.id}"
  cidr_block        = "172.16.6.0/24"
  availability_zone = "${lookup(var.AWS_AZ_B, var.AWS_REGION)}"
  map_public_ip_on_launch = true

  tags = {
    Name    = "staging-public-subnet-b"
    Init = "terraform"
    Recipe  = "${var.IAC_REPO_BRANCH}"
  }
}
resource "aws_subnet" "staging-public-subnet-c" {
  vpc_id            = "${aws_vpc.staging-vpc.id}"
  cidr_block        = "172.16.7.0/24"
  availability_zone = "${lookup(var.AWS_AZ_C, var.AWS_REGION)}"
  map_public_ip_on_launch = true

  tags = {
    Name    = "staging-public-subnet-c"
    Init = "terraform"
    Recipe  = "${var.IAC_REPO_BRANCH}"
  }
}

## Internet Gateway
## staging IGW
resource "aws_internet_gateway" "staging-igw" {
  vpc_id = "${aws_vpc.staging-vpc.id}"

  tags = {
    Name    = "staging-igw"
    Init = "terraform"
    Recipe  = "${var.IAC_REPO_BRANCH}"
  }
}

## Route tables
## Route Public  to IGW and peering
resource "aws_route_table" "staging-route-live-rtb" {
  vpc_id = "${aws_vpc.staging-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.staging-igw.id}"
  }
  route {
    cidr_block = "172.19.0.0/16"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.middleware-to-staging-vpc.id}"
  }

  tags = {
    Name    = "staging-route-live-rtb"
    Init = "terraform"
    Recipe  = "${var.IAC_REPO_BRANCH}"
  }
}

## Route live subnet association to IGW
resource "aws_route_table_association" "staging-public-subnet-assoc-a" {
  subnet_id      = "${aws_subnet.staging-public-subnet-a.id}"
  route_table_id = "${aws_route_table.staging-route-live-rtb.id}"
}

resource "aws_route_table_association" "staging-public-subnet-assoc-b" {
  subnet_id      = "${aws_subnet.staging-public-subnet-b.id}"
  route_table_id = "${aws_route_table.staging-route-live-rtb.id}"
}

resource "aws_route_table_association" "staging-public-subnet-assoc-c" {
  subnet_id      = "${aws_subnet.staging-public-subnet-c.id}"
  route_table_id = "${aws_route_table.staging-route-live-rtb.id}"
}

#### RDS ####
#### Subnet Group #####
resource "aws_db_subnet_group" "private-staging-db-subnet-group" {
  name        = "private-staging-db-subnet-group"
  subnet_ids  = [
                 "${aws_subnet.staging-private-subnet-a.id}",
                 "${aws_subnet.staging-private-subnet-b.id}",
                 "${aws_subnet.staging-private-subnet-c.id}"
                ]

  tags = {
    Name    = "private-staging-db-subnet-group"
    Init    = "terraform"
    Recipe  = "${var.IAC_REPO_BRANCH}"
  }
}

resource "aws_db_subnet_group" "public-staging-db-subnet-group" {
  name        = "public-staging-db-subnet-group"
  subnet_ids  = [
                 "${aws_subnet.staging-public-subnet-a.id}",
                 "${aws_subnet.staging-public-subnet-b.id}",
                 "${aws_subnet.staging-public-subnet-c.id}"
                ]

  tags = {
    Name    = "public-staging-db-subnet-group"
    Init    = "terraform"
    Recipe  = "${var.IAC_REPO_BRANCH}"
  }
}

