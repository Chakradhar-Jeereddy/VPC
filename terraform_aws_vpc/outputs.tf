output "vpc_id" {
    value = aws_vpc.cyber.id
}

output "subnet" {
    value = aws_subnet.public
}