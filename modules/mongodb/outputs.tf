output "public_ip" {
  value = aws_instance.mongodb_instance.public_ip
}

output "private_ip" {
  value = aws_instance.mongodb_instance.private_ip
}

# output "mongodb_public_ip" {
#   value = module.mongodb.public_ip
# }

# output "mongodb_private_ip" {
#   value = module.mongodb.private_ip
# }

# output "load_balancer_dns" {
#   value = aws_lb.mean_lb.dns_name
# }