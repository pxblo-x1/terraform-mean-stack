variable "mongo_ami_id" {
  description = "AMI ID for MongoDB"
  type        = string
  default     = "ami-0462db0f8d05d8090"
}

variable "ami_id" {
  description = "AMI ID for MongoDB"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for MongoDB"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "nginx_subnet_cidr" {
  description = "CIDR block for the Nginx subnet"
  type        = string
}