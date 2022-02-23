output "out_vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.my_vpc.id
}

output "out_vpc_name" {
  description = "name of the vpc"
  value       = aws_vpc.my_vpc.tags.Name
}
