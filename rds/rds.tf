resource "aws_db_instance" "bit-rnd" {
 
  engine                          = "postgres"
  identifier                      = "bit-rnd"
  allocated_storage               = 30
  instance_class                  = "db.t3.micro"
  engine_version                  = "10.22"
  username                        = "administrator"
  password                        = "C0b4LahS4j483"
  publicly_accessible             = true
  skip_final_snapshot             = false
  db_subnet_group_name            = "public-staging-db-subnet-group"
  vpc_security_group_ids          = [
                                     "sg-0ea72750368d3416e"
                                    ]
  tags = {
    Name         = "bit-rnd"
    Init         = "terraform"
    
  }
}
