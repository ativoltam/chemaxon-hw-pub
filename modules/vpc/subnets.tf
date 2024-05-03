# NAT
resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id
}

# Public subnets
resource "aws_subnet" "public" {
  count = length(var.availability_zones)

  # CIDR blocks for public subnets:
  #   - 10.x.32.0/20
  #   - 10.x.96.0/20
  #   - 10.x.160.0/20
  #   - 10.x.224.0/20
  #
  cidr_block = cidrsubnet(var.cidr, 4, count.index * 4 + 2)

  vpc_id                  = aws_vpc.main.id
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name                                       = "${var.name}-pub-${element(var.availability_zones, count.index)}"
  }

  depends_on = [aws_internet_gateway.main]
}

# Routing table for public subnets
# Everything is routed through the IGW
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name   = "${var.name}-public"
  }
}

resource "aws_route" "internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

# Associate public route table to subnets
resource "aws_route_table_association" "public" {
  count = length(var.availability_zones)

  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

# Private subnets
resource "aws_subnet" "private" {
  count = length(var.availability_zones)

  # CIDR blocks for private subnets:
  #   - 10.x.0.0/19
  #   - 10.x.64.0/19
  #   - 10.x.128.0/19
  #   - 10.x.192.0/19
  #
  cidr_block = cidrsubnet(var.cidr, 3, count.index * 2)

  vpc_id                  = aws_vpc.main.id
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name                                       = "${var.name}-pri-${element(var.availability_zones, count.index)}"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name   = "${var.name}-private"
  }
}

resource "aws_route" "nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main.id
}

resource "aws_route_table_association" "private" {
  count = length(var.availability_zones)

  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private.id
}

# Endpoints
resource "aws_vpc_endpoint" "s3" {
  vpc_id          = aws_vpc.main.id
  route_table_ids = concat(aws_route_table.private.*.id, aws_route_table.public.*.id)
  service_name    = "com.amazonaws.${var.region}.s3"
}
