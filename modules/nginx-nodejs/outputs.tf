output "nginx_nodejs_instance_id" {
  value = [for instance in aws_instance.nginx_nodejs_instance : instance.id]
}

output "nginx_nodejs_sg_id" {
  value = aws_security_group.nginx_nodejs_sg.id
}
