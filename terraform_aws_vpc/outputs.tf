output "vpc_id" {
    value = aws_vpc.cyber.id
}

output "subnet" {
    value = aws_subnet.public
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "database_subnet_ids" {
  value = aws_subnet.database[*].id
}
