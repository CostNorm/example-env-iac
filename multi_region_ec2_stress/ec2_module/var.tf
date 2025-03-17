variable "vpc_id" {}
variable "subnet_id" {}
variable "cpu_utilization" {
  description = "Target CPU utilization percentage (0-100)"
  type        = number
  default     = 70

  validation {
    condition     = var.cpu_utilization > 0 && var.cpu_utilization <= 100
    error_message = "CPU utilization must be between 1 and 100"
  }
}
variable "ec2_profile_name" {}