# Cloudrock vpc
resource "aws_vpc" "cloudrock_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  instance_tenancy = "default"

  tags = {
    Name = "cloudrock_vpc"
  }
}

# use data to get the availability zones
data "aws_availability_zones" "availability_zones" {}



# web public subnet1
resource "aws_subnet" "web_publicsubnet1" {
  vpc_id     = aws_vpc.cloudrock_vpc.id
  cidr_block =  "10.0.10.0/24"
  availability_zone = data.aws_availability_zones.availability_zones.names[0]
  tags = {
    Name = "web_publicsubnet1"
  }
}
#web public subnet2 
resource "aws_subnet" "web_publicsubnet2" {
  vpc_id     = aws_vpc.cloudrock_vpc.id
  cidr_block =   "10.0.11.0/24"
  availability_zone = data.aws_availability_zones.availability_zones.names[2]

  tags = {
    Name = "web_publicsubnet2"
  }
}


#web private subnet1 
resource "aws_subnet" "web_privatesubnet1" {
  vpc_id     = aws_vpc.cloudrock_vpc.id
  cidr_block =  "10.0.12.0/24"
  availability_zone = data.aws_availability_zones.availability_zones.names[0]

  tags = {
    Name = "web_privatesubnet1"
  }
}

#web private subnet2 
resource "aws_subnet" "web_privatesubnet2" {
  vpc_id     = aws_vpc.cloudrock_vpc.id
  cidr_block =  "10.0.13.0/24"
  availability_zone = data.aws_availability_zones.availability_zones.names[0]

  tags = {
    Name = "web_privatesubnet2"
  }
}

# web internate gateway

resource "aws_internet_gateway" "web-igw" {
  vpc_id = aws_vpc.cloudrock_vpc.id

  tags = {
    Name = "web"
  }
}

#eip 
resource "aws_eip" "web_eip" {
}


#Nat gateway 
resource "aws_nat_gateway" "web_nat" {
  allocation_id = aws_eip.web_eip.id
  subnet_id     = aws_subnet.web_privatesubnet1.id

  tags = {
    Name = "web_nat"
  }
}

# web public routetable
resource "aws_route_table" "web_publicrt" {
  vpc_id = aws_vpc.cloudrock_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.web-igw.id
  }
  tags = {
    Name = "web_publicrt "
  }
}

# web private rt
resource "aws_route_table" "web_privatert" {
  vpc_id = aws_vpc.cloudrock_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.web_nat.id
  }
  tags = {
    Name = "web_nat"
  }
}

# public rt public subnet association_" 
resource "aws_route_table_association" "web_publicsubnet_publicrt_association" {
  subnet_id      = aws_subnet.web_publicsubnet1.id
  route_table_id = aws_route_table.web_publicrt.id
}
  

# private rt private subnet association
resource "aws_route_table_association" "web_privatesubnet_privatert_association" {
  subnet_id      = aws_subnet.web_privatesubnet1.id
  route_table_id = aws_route_table.web_privatert.id
}








