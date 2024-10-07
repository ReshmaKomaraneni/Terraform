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

#create NACL's
#Web NACL
resource "aws_network_acl" "ecomm-app-wb-nacl" {
  vpc_id = aws_vpc.ecomm-app.id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "ecomm-app-web-nacl"
  }
}

#Api NACL
resource "aws_network_acl" "ecomm-app-api-nacl" {
  vpc_id = aws_vpc.ecomm-app.id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "ecomm-app-api-nacl"
  }
}

#Database NACL
resource "aws_network_acl" "ecomm-app-db-nacl" {
  vpc_id = aws_vpc.ecomm-app.id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "ecomm-app-database-nacl"
  }
}

#Nacl web association
resource "aws_network_acl_association" "ecomm-app-web-nacl-asc" {
  network_acl_id = aws_network_acl.ecomm-app-wb-nacl.id
  subnet_id      = aws_subnet.ecomm-web-sn.id
}

#Nacl api association
resource "aws_network_acl_association" "ecomm-app-api-nacl-asc" {
  network_acl_id = aws_network_acl.ecomm-app-api-nacl.id
  subnet_id      = aws_subnet.ecomm-api-sn.id
}

#Nacl database association
resource "aws_network_acl_association" "ecomm-app-db-nacl-asc" {
  network_acl_id = aws_network_acl.ecomm-app-db-nacl.id
  subnet_id      = aws_subnet.ecomm-db-sn.id
}


#create security groups
#web sg
resource "aws_security_group" "ecomm-web-sg" {
  name        = "ecomm-web-sg"
  description = "Allow SSH and HTTP traffic"
  vpc_id      = aws_vpc.ecomm-app.id

  tags = {
    Name = "ecomm-web-sg"
  }
}

#adding inbound rules for web sg(ingress)
resource "aws_vpc_security_group_ingress_rule" "ecomm-web-sg-ingress-ssh" {
  security_group_id = aws_security_group.ecomm-web-sg.id
  cidr_ipv4         = "0.0.0./0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "ecomm-web-sg-ingress-http" {
  security_group_id = aws_security_group.ecomm-web-sg.id
  cidr_ipv4         = "0.0.0./0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

#adding outbound rules for web sg(egress)
resource "aws_vpc_security_group_egress_rule" "ecomm-web-sg-egress" {
  security_group_id = aws_security_group.ecomm-web-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}