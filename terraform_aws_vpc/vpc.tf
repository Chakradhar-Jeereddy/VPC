# Creating VPC
resource "aws_vpc" "cyber" {
  cidr_block       = var.cidr
  instance_tenancy = var.tenancy
  enable_dns_hostnames = true

  tags = merge (
    var.vpc_tags,
    local.common_tags,
    {
        Name = local.common_name_suffix
    }
  )
}

# Creating Internet gateway
resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.cyber.id

  tags = merge (
    var.igw_tags,
    local.common_tags,
    {
        Name = local.common_name_suffix
    }
  )
}

# Creating public subnet
resource "aws_subnet" "public" {
  count = length(var.public_cidr)
  vpc_id     = aws_vpc.cyber.id
  cidr_block = var.public_cidr[count.index]
  availability_zone = local.public_az[count.index]
  map_public_ip_on_launch = true

  tags = merge (
    var.igw_tags,
    local.common_tags,
    {
        Name = "${local.common_name_suffix}-public-${local.public_az[count.index]}"
        # roboshop-dev-public-us-east-1a
    }
  )
}

#Creating private subnet
resource "aws_subnet" "private" {
  count = length(var.private_cidr)
  vpc_id     = aws_vpc.cyber.id
  cidr_block = var.private_cidr[count.index]
   availability_zone = local.private_az[count.index]

  tags = merge (
    var.igw_tags,
    local.common_tags,
    {
        Name = "${local.common_name_suffix}-private-${local.private_az[count.index]}"
        # roboshop-dev-private-us-east-1c
    }
  )
}

#Creating database subnet
resource "aws_subnet" "database" {
  count = length(var.database_cidr)
  vpc_id     = aws_vpc.cyber.id
  cidr_block = var.database_cidr[count.index]
   availability_zone = local.database_az[count.index]

  tags = merge (
    var.igw_tags,
    local.common_tags,
    {
        Name = "${local.common_name_suffix}-database-${local.database_az[count.index]}"
        # roboshop-dev-private-us-east-1c
    }
  )
}

#Creating public routable
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.cyber.id

  tags = merge (
    var.route_tags,
    local.common_tags,
    {
        Name = "${local.common_name_suffix}-public-route"
        # roboshop-dev-public-route
    }
  )
}

#Creating private routetable
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.cyber.id

  tags = merge (
    var.route_tags,
    local.common_tags,
    {
        Name = "${local.common_name_suffix}-private-route"
        # roboshop-dev-private-route
    }
  )
}

#Creating database routetable
resource "aws_route_table" "database" {
  vpc_id = aws_vpc.cyber.id

  tags = merge (
    var.route_tags,
    local.common_tags,
    {
        Name = "${local.common_name_suffix}-database-route"
        # roboshop-dev-database-route
    }
  )
}

#Create elastic ip
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = merge (
    var.route_tags,
    local.common_tags,
    {
        Name = "${local.common_name_suffix}-eip"
        # roboshop-dev-database-route
    }
  )
}

#Create nat gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge (
    var.route_tags,
    local.common_tags,
    {
        Name = "${local.common_name_suffix}-nat"
        # roboshop-dev-database-eip
    }
  )
  # on the Internet Gateway for the VPC.
  depends_on = [ aws_internet_gateway.gateway ]
}

#Routes from public subnet to igw
resource "aws_route" "public" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gateway.id
}

#Routes from private subnet to nat
resource "aws_route" "private" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id= aws_nat_gateway.nat.id
}

#Routes from database subnet to nat
resource "aws_route" "database" {
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id= aws_nat_gateway.nat.id
}

#Associate to public subnet to public route table
resource "aws_route_table_association" "public" {
  count = length(var.public_cidr)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id 
}

#Associate to private subnet to private route table
resource "aws_route_table_association" "private" {
  count = length(var.private_cidr)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id 
}

#Associate to database subnet to database route table
resource "aws_route_table_association" "database" {
  count = length(var.database_cidr)
  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database.id 
}