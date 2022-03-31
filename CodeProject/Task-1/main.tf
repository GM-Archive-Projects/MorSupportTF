
#VPC
resource "aws_vpc" "vpc" {
    cidr_block    = var.cidr_default
    tags = {
        Name = "${var.prefix}-VPC"

  }
}


#Subnets

#Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.prefix}-IGW"
  }
}

# elastic ip for the nat gateway
resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
}





# Nat gateway for the private subnets
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = element(aws_subnet.public.*.id, 0)
  depends_on    = [aws_internet_gateway.igw]
  tags = {
    Name = "${var.prefix}-nat"
  }
}




# Public subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.public_cidr)
  cidr_block              = element(var.public_cidr, count.index)
  availability_zone       = element(var.az_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env}-${element(var.az_zones, count.index)}-public"
  }
}





# Private subnets
resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.private_cidr)
  cidr_block              = element(var.private_cidr, count.index)
  availability_zone       = element(var.az_zones, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.env}-${element(var.az_zones, count.index)}-private"
  }
}




# Private subnets route table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.prefix}-private-route-table"
  }
}

# Public subnets route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.prefix}-public-route-table"
  }
}



# Add route for public route table to internet gateway
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}


# Add route for private route table to nat gateway
resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}


# Associate the public route table to public subnets
resource "aws_route_table_association" "public" {
  count          = length(var.public_cidr)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}


# Associate the public route table to public subnets
resource "aws_route_table_association" "private" {
  count          = length(var.private_cidr)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private.id
}




# Create a default security for the vpc
resource "aws_security_group" "default" {
  name        = "${var.prefix}-default-sg"
  description = "Default security group to allow inbound/outbound from the VPC"
  vpc_id      = aws_vpc.vpc.id
  depends_on  = [aws_vpc.vpc]

  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = "true"
  }
  tags = {
    Name = "${var.prefix}-security_group"
  }
}