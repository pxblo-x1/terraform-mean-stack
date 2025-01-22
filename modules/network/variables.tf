variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "nginx_subnet_cidr" {
  description = "CIDR block for the Nginx subnet"
  type        = string
}

variable "mongodb_subnet_cidr" {
  description = "CIDR block for the MongoDB subnet"
  type        = string
}