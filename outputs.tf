output "nginx_nodejs_public_ip" {
  value = module.nginx_nodejs.public_ip
}

output "nginx_nodejs_private_ip" {
  value = module.nginx_nodejs.private_ip
}

output "mongodb_public_ip" {
  value = module.mongodb.public_ip
}

output "mongodb_private_ip" {
  value = module.mongodb.private_ip
}

output "load_balancer_dns" {
  value = aws_lb.mean_lb.dns_name
}

output "nat_gateway_public_ip" {
  value = aws_eip.nat.public_ip
}

