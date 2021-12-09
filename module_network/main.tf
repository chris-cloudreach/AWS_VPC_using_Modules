resource "aws_vpc" "main" {
  cidr_block = "192.168.0.0/16"
  tags = {
    Name = "talent-academy-main-vpc"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.IG_name
  }
}

resource "aws_subnet" "public_a_cidr" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_a_cidr
  map_public_ip_on_launch = true
  availability_zone = "${var.region}a"
  tags = {
    Name = var.public_subnet_a 
  }
}
resource "aws_subnet" "public_b_cidr" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_b_cidr
  availability_zone = "${var.region}b"
  map_public_ip_on_launch = true
  tags = {
    Name = var.public_subnet_b 
  }
}
resource "aws_subnet" "public_c_cidr" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_c_cidr
  availability_zone = "${var.region}c"
  map_public_ip_on_launch = true
  tags = {
    Name = var.public_subnet_c 
  }
}

# PRIVATE SUBNETS
resource "aws_subnet" "private_a_cidr" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_a_cidr
  
  availability_zone = "${var.region}a"
  tags = {
    Name = "private-subnet-a"
  }
}
resource "aws_subnet" "private_b_cidr" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_b_cidr
  availability_zone = "${var.region}b"
  
  tags = {
    Name = "private-subnet-b"
  }
}
resource "aws_subnet" "private_c_cidr" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_c_cidr
  availability_zone = "${var.region}c"
  
  tags = {
    Name = "private-subnet-c"
  }
}

# NAT GATEWAY
resource "aws_eip" "nat_a_eip" {
  vpc = true
  tags = {
    Name = "talent-academy-eip"
  }
}

resource "aws_nat_gateway" "NAT_public_subnet_a" {
  allocation_id = aws_eip.nat_a_eip.id
  subnet_id     = aws_subnet.public_a_cidr.id

  tags = {
    Name = "NATGATEWAY FOR SUBNET A"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}
#...............

resource "aws_eip" "nat_b_eip" {
  vpc = true
  tags = {
    Name = "talent-academy-eip-b"
  }
}

resource "aws_nat_gateway" "NAT_public_subnet_b" {
  allocation_id = aws_eip.nat_b_eip.id
  subnet_id     = aws_subnet.public_a_cidr.id

  tags = {
    Name = "NATGATEWAY FOR SUBNET B"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}


resource "aws_eip" "nat_c_eip" {
  vpc = true
  tags = {
    Name = "talent-academy-eip-c"
  }
}

resource "aws_nat_gateway" "NAT_public_subnet_c" {
  allocation_id = aws_eip.nat_c_eip.id
  subnet_id     = aws_subnet.public_a_cidr.id

  tags = {
    Name = "NATGATEWAY FOR SUBNET C"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}