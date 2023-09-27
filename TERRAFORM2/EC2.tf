resource "aws_key_pair" "web_keypair" {
  key_name   = "web_keypair"
  public_key = tls_private_key.rsa.public_key_openssh
}


# RSA key of size 4096 bits
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "web_keypair" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "web_keypair"
}

resource "aws_instance" "ec2_webserver1" {
  ami = "ami-0f3d9639a5674d559"
  instance_type = "t2.micro"
  tags = {
    Name = "ec2_webserver1"
  }
  key_name= "web_keypair"
  subnet_id = "web_publicsubnet1.id"
  vpc_security_group_ids = [aws_security_group.web_SG.id]
  count = 2
}



resource "aws_instance" "ec2_webserver2" {
  ami = "ami-0f3d9639a5674d559"
  instance_type = "t2.micro"
  tags = {
    Name = "ec2_webserver2"
  }
  key_name= "web_keypair"
  subnet_id = "web_privatesubnet1.id"
  vpc_security_group_ids = [aws_security_group.web_SG.id]
  associate_public_ip_address = true
   
}

