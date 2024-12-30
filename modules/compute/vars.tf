variable "environment" {
  description = "The deployment environment (must be 'dev' or 'prod', in lowercase)"
  type        = string

  validation {
    condition     = lower(var.environment) == var.environment && contains(["dev", "prod"], var.environment)
    error_message = "The environment must be either 'dev' or 'prod' and must be in lowercase."
  }
}


variable "distro_version" {
  description = "The version of the Linux distribution"
  type        = string
  default     = "24.04" 
}

variable "security_group_id" {
}

variable "subnet_id" {
}

variable "instance_count" {
  description = "number of instances"
  type = number
  default = 2
}

variable "ansible_controller-sg" {
  
}

variable "instance_profile" {
  default = ""
}

variable "instance_type" {
}

variable "private_key" {
}

variable "tls_key" {
}
