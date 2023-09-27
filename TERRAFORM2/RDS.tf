resource "aws_db_instance" "mydbs" {
  allocated_storage    = 20
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  username             = "admin"
  password             = "faith1994@"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  
  tags = {
    NAME = "mydbs"

  }

} 
