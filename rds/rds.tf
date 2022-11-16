resource "aws_db_instance" "dev-asgard-rds" {
 
  engine                          = "postgres"
  identifier                      = "bit-rnd"
  allocated_storage               = 30
  instance_class                  = "db.t3.micro"
  engine_version                  = "10.22"
  username                        = "sys-admin"
  password                        = "C0b4LahS^j483"
  publicly_accessible             = true
  skip_final_snapshot             = false
  db_subnet_group_name            = "public-staging-db-subnet-group"
  vpc_security_group_ids          = [
                                     "sg-00f17554e814f4e61"
                                    ]
  tags = {
    Name         = "bit-rnd"
    Init         = "terraform"
    
  }
}
