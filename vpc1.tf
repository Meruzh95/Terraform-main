resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.11.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1a"
  tags = {
    Name = "${var.project_name}-public-subnet-1"
  }
}

resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.21.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1b"
  tags = {
    Name = "${var.project_name}-public-subnet-2"
  }
}

resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

resource "aws_route_table" "RT-public1" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }

  tags = {
    Name = "${var.project_name}-route-table1"
  }
}

resource "aws_route_table" "RT-public2" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }

  tags = {
    Name = "${var.project_name}-route-table2"
  }
}

resource "aws_route_table_association" "RT-IGW-association1" {
   subnet_id      = aws_subnet.public1.id
   route_table_id = aws_route_table.RT-public1.id
}


resource "aws_route_table_association" "RT-IGW-association2" {
   subnet_id      = aws_subnet.public2.id
   route_table_id = aws_route_table.RT-public2.id
}



resource "aws_instance" "ubuntu" {
  ami           = "ami-052efd3df9dad4825"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.devops.key_name
  subnet_id     = aws_subnet.public1.id
  vpc_security_group_ids  = [aws_security_group.allow_ssh.id]
  tags = {
    Name = "${var.project_name}-public-instance"
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow ssh"
  description = "allow SSH inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  tags = {
    Name = "Allow SSH"
  }
}



# resource "aws_subnet" "Private1" {
#   vpc_id     = aws_vpc.main.id
#   cidr_block = "10.0.12.0/24"
#   availability_zone = "us-east-1a"

#   tags = {
#     Name = "Private1"
#   }
# }



# resource "aws_subnet" "Private2" {
#   vpc_id     = aws_vpc.main.id
#   cidr_block = "10.0.22.0/24"
#   availability_zone = "us-east-1b"

#   tags = {
#     Name = "Private2"
#   }
# }


# resource "aws_subnet" "DB1" {
#   vpc_id     = aws_vpc.main.id
#   cidr_block = "10.0.13.0/24"
#   availability_zone = "us-east-1a"

#   tags = {
#     Name = "DB1"
#   }
# }


# resource "aws_subnet" "DB2" {
#   vpc_id     = aws_vpc.main.id
#   cidr_block = "10.0.23.0/24"
#   availability_zone = "us-east-1b"

#   tags = {
#     Name = "DB2"
#   }
# }






# resource "aws_route_table" "RT-private1" {
#   vpc_id = aws_vpc.main.id

#   route {
#     cidr_block = "10.0.12.0/24"
#     nat_gateway_id = aws_nat_gateway.NAT1.id
#   }
# }

# resource "aws_route_table" "RT-private2" {
#   vpc_id = aws_vpc.main.id

#   route {
#     cidr_block = "10.0.22.0/24"
#     nat_gateway_id = aws_nat_gateway.NAT2.id
#   }
# }



# resource "aws_nat_gateway" "NAT1" {
#   allocation_id = aws_eip.eip-for-nat-gateway-1.id
#   subnet_id     = aws_subnet.public1.id

#   tags = {
#     Name = "NAT1"
#   }
# }


# resource "aws_nat_gateway" "NAT2" {
#   allocation_id = aws_eip.eip-for-nat-gateway-2.id
#   subnet_id     = aws_subnet.public2.id

#   tags = {
#     Name = "NAT1"
#   }
# }

# resource "aws_eip" "eip-for-nat-gateway-1" {
#   vpc    = true

#   tags   = {
#     Name = "EIP for Nat1"
#   }
# }


# resource "aws_eip" "eip-for-nat-gateway-2" {
#   vpc    = true

#   tags   = {
#     Name = "EIP for Nat2"
#   }
# }

