resource "aws_instance" "nginx_nodejs_instance" {
  count                  = 2
  ami                    = var.ami_id
  instance_type          = "t2.micro"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.nginx_nodejs_sg.id]
  associate_public_ip_address = true
  
  user_data = <<-EOF
              #!/bin/bash
              echo "<h1>Server $((count.index + 1)) - Instance ID: $(curl -s http://169.254.169.254/latest/meta-data/instance-id)</h1>" > /var/www/html/index.html
              systemctl enable nginx
              systemctl restart nginx
              EOF
  tags = {
    Name = "nginx-instance-${count.index}"
  }
}

resource "aws_security_group" "nginx_nodejs_sg" {
  name        = "nginx-nodejs-sg"
  description = "Security group for Nginx and Node.js"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "public_ip" {
  value = [for instance in aws_instance.nginx_nodejs_instance : instance.public_ip]
}

output "private_ip" {
  value = [for instance in aws_instance.nginx_nodejs_instance : instance.private_ip]
}
