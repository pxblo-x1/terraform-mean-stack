variable "region" {
  description = "AWS region"
  type        = string
}

variable "nginx_ami_id" {
  description = "AMI ID for Nginx and Node.js"
  type        = string
}

variable "mongodb_ami_id" {
  description = "AMI ID for MongoDB"
  type        = string
}

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

variable "nginx_availability_zone_1" {
  description = "Availability zone for the Nginx subnet"
  type        = string
}

variable "nginx_availability_zone_2" {
  description = "Availability zone for the Nginx subnet"
  type        = string
}

provider "aws" {
  region = var.region
}
