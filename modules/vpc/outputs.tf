output "id" {
  value = aws_vpc.main.id
}

## Availability zones

output "availability_zones" {
  value = var.availability_zones
}

output "primary_availability_zone" {
  value = var.availability_zones[0]
}

output "secondary_availability_zone" {
  value = var.availability_zones[1]
}

## Subnets

output "extended_private_subnet_ids" {
  value = aws_subnet.private.*.id
}
output "extended_public_subnet_ids" {
  value = aws_subnet.public.*.id
}

output "private_subnet_ids" {
  value = slice(aws_subnet.private.*.id, 0, 2)
}
output "public_subnet_ids" {
  value = slice(aws_subnet.public.*.id, 0, 2)
}

output "primary_public_subnet_id" {
  value = aws_subnet.public[0].id
}

output "primary_private_subnet_id" {
  value = aws_subnet.private[0].id
}

output "secondary_public_subnet_id" {
  value = aws_subnet.public[1].id
}

output "secondary_private_subnet_id" {
  value = aws_subnet.private[1].id
}

## Route tables

output "private_route_table" {
  value = aws_route_table.private.id
}

output "public_route_table" {
  value = aws_route_table.public.id
}

