variable "node_ami_id" {
  description = "AMI ID for Nginx and Node.js"
  type        = string
  default     = "ami-0be557b0f2fdf3868"
}

variable "ami_id" {
  description = "AMI ID for Nginx and Node.js"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for Nginx and Node.js"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}