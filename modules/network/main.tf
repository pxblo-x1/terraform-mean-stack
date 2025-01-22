resource "aws_vpc" "mean_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
}

resource "aws_subnet" "nginx_subnet_1" {
  vpc_id            = aws_vpc.mean_vpc.id
  cidr_block        = var.nginx_subnet_cidr
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "nginx_subnet_2" {
  vpc_id            = aws_vpc.mean_vpc.id
  cidr_block        = "10.0.3.0/24" # New CIDR for second subnet
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "mongodb_subnet" {
  vpc_id            = aws_vpc.mean_vpc.id
  cidr_block        = var.mongodb_subnet_cidr
  availability_zone = "us-east-1b" # Specify your desired AZ
  map_public_ip_on_launch = true
}

output "mongodb_subnet_id" {
  value = aws_subnet.mongodb_subnet.id
}
