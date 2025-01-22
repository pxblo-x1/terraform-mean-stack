module "network" {
  source              = "./modules/network"
  vpc_cidr            = var.vpc_cidr
  nginx_subnet_cidr   = var.nginx_subnet_cidr
  mongodb_subnet_cidr = var.mongodb_subnet_cidr
}

module "nginx_nodejs" {
  source    = "./modules/nginx-nodejs"
  ami_id    = var.nginx_ami_id
  subnet_id = module.network.nginx_subnet_ids[0]
  vpc_id    = module.network.vpc_id
}

module "mongodb" {
  source            = "./modules/mongodb"
  ami_id            = var.mongodb_ami_id
  subnet_id         = module.network.mongodb_subnet_id
  vpc_id            = module.network.vpc_id
  nginx_subnet_cidr = module.network.nginx_subnet_cidr
}

resource "aws_lb" "mean_lb" {
  name               = "mean-stack-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = module.network.nginx_subnet_ids

  enable_deletion_protection = false

  timeouts {
    create = "5m"
    update = "5m"
    delete = "5m"
  }

}

resource "aws_internet_gateway" "igw" {
  vpc_id = module.network.vpc_id # Use the VPC from network module
}

resource "aws_lb_target_group" "mean_tg" {
  name     = "mean-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.network.vpc_id 

}

resource "aws_lb_listener" "mean_listener" {
  load_balancer_arn = aws_lb.mean_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.mean_tg.arn
  }
  timeouts {
    create = "5m"
    update = "5m"
  }
}

resource "aws_lb_target_group_attachment" "nginx_nodejs" {
  count            = 2
  target_group_arn = aws_lb_target_group.mean_tg.arn
  target_id        = module.nginx_nodejs.nginx_nodejs_instance_id[count.index]
  port             = 80
}
resource "aws_eip" "nat" {
  associate_with_private_ip = true
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = module.network.nginx_subnet_ids[0]  # Changed to use first subnet from the list
  depends_on    = [aws_internet_gateway.igw]
}

resource "aws_security_group" "lb_sg" {
  name        = "lb_sg"
  description = "Security group for load balancer"
  vpc_id      = module.network.vpc_id # Use the VPC from network module

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

resource "aws_security_group_rule" "nginx_from_lb" {
  type                      = "ingress"
  from_port                 = 80
  to_port                   = 80
  protocol                  = "tcp"
  source_security_group_id  = aws_security_group.lb_sg.id
  security_group_id         = module.nginx_nodejs.nginx_nodejs_sg_id  # Changed from security_group_id to nginx_nodejs_sg_id
  description               = "Allow traffic from load balancer"
}

# Create route table for public subnets
resource "aws_route_table" "public" {
  vpc_id = module.network.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public"
  }
}

# Create route table for private subnets
resource "aws_route_table" "private" {
  vpc_id = module.network.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "private"
  }
}

# Associate public subnets with public route table
resource "aws_route_table_association" "public_1" {
  subnet_id      = module.network.nginx_subnet_ids[0]
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = module.network.nginx_subnet_ids[1]
  route_table_id = aws_route_table.public.id
}

# Associate MongoDB subnet with private route table
# resource "aws_route_table_association" "private" {
#   subnet_id      = module.network.mongodb_subnet_id
#   route_table_id = aws_route_table.private.id
# }

resource "aws_route_table_association" "mongodb_public" {
  subnet_id      = module.network.mongodb_subnet_id
  route_table_id = aws_route_table.public.id  # Use public route table instead of private
}