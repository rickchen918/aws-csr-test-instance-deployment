variable "owner" {
    type = string
}

variable "image_desc" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "key_name" {
  type = string
}

variable "associate_public_ip_address" {
  type = bool
  default = true
}

variable "vpc_security_group_ids" {
  type = string
}

variable "tags" {
  type = string
  default = null
}