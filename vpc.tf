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
  map_public_ip_on_launch="true"

  tags = {
    Name = "ecomm-web-subnet"
  }
}

#api subnet
resource "aws_subnet" "ecomm-api-sn" {
  vpc_id     = aws_vpc.ecomm-app.id
  cidr_block = "10.0.2.0/25"
  map_public_ip_on_launch="true"

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

# create internet gateway
resource "aws_internet_gateway" "ecomm-igw" {
  vpc_id = aws_vpc.ecomm-app.id

  tags = {
    Name = "ecomm-igw"
  }
}
#attach internet gateway to vpc(Associate to vpc)
resource "aws_internet_gateway_attachment" "ecomm1-app" {
  internet_gateway_id = aws_internet_gateway.ecomm1-app.id
  vpc_id              = aws_vpc.ecomm1-app.id
}

resource "aws_vpc" "ecomm1-app" {
  cidr_block = "10.1.0.0/16"
}

resource "aws_internet_gateway" "ecomm1-app" {}

#create route tables
#public route table
resource "aws_route_table" "ecomm-pub-rt" {
  vpc_id = aws_vpc.ecomm-app.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ecomm-igw.id
  }

  tags = {
    Name = "ecomm-public-rt"
  }
}

#private route table
resource "aws_route_table" "ecomm-prv-rt" {
  vpc_id = aws_vpc.ecomm-app.id

tags = {
    Name = "ecomm-private-rt"
  }
}

 #add subnets to the route tables(Associate Subnets to the Route Tables)
 #public association
 resource "aws_route_table_association" "ecomm-web-sn-asc" {
  subnet_id      = aws_subnet.ecomm-web-sn.id
  route_table_id = aws_route_table.ecomm-pub-rt.id
} 

resource "aws_route_table_association" "ecomm-api-sn-asc" {
  subnet_id      = aws_subnet.ecomm-api-sn.id
  route_table_id = aws_route_table.ecomm-pub-rt.id
} 

#private association
resource "aws_route_table_association" "ecomm-db-sn-asc" {
  subnet_id      = aws_subnet.ecomm-db-sn.id
  route_table_id = aws_route_table.ecomm-prv-rt.id
}
