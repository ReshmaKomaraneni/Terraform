#create vpc
resource "aws_vpc" "ecomm-app" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "ecomm-app"
  }
}
#create subnet
#web subnet
resource "aws_subnet" "ecomm-web-sn" {
  vpc_id     = aws_vpc.ecomm-app.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "ecomm-web-subnet"
  }
}

#api subnet
resource "aws_subnet" "ecomm-api-sn" {
  vpc_id     = aws_vpc.ecomm-app.id
  cidr_block = "10.0.2.0/25"

  tags = {
    Name = "ecomm-api-subnet"
  }
}

#database subnet
resource "aws_subnet" "ecomm-db-sn" {
  vpc_id     = aws_vpc.ecomm-app.id
  cidr_block = "10.0.3.0/26"

  tags = {
    Name = "ecomm-database-subnet"
  }
}