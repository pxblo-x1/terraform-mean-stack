
output "nginx_subnet_id" {
  value = aws_subnet.nginx_subnet_1.id  # Changed from nginx_subnet to nginx_subnet_1
}

output "vpc_id" {
  value = aws_vpc.mean_vpc.id
}

output "nginx_subnet_cidr" {
  value = aws_subnet.nginx_subnet_1.cidr_block  # Changed from nginx_subnet to nginx_subnet_1
}

output "nginx_subnet_ids" {
  value = [aws_subnet.nginx_subnet_1.id, aws_subnet.nginx_subnet_2.id]
}

# output "nginx_nodejs_instance_id" {
#   value = aws_instance.nginx_nodejs_instance.id
# }

# output "nginx_nodejs_sg_id" {
#   value = aws_security_group.nginx_nodejs_sg.id
# }