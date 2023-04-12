variable "aws_region" {
    description = "AWS region"
    type        = string
    default     = "us-east-1"
}
variable "project_name" {
    type = string
    description = "Project name"
}
variable "environment" {
    description = "Environment name"
    type        = string
    default     = "dev"
    validation {
        condition = length(var.environment) > 2 && length(var.environment) < 64 && can(regex("^[0-9A-Za-z-]+$", var.environment))
        error_message = "The environment must follow naming rules."
    }
}
variable "activate_kms" {
    description = "Activate KMS"
    type        = bool
    default     = false
}
variable "users_ready_only" {
    description = "Users ARN"
    type        = list(string)
}
variable "users_write_permissions" {
    description = "Users ARN"
    type        = list(string)
}
variable "tags" {
    description = "A map of tags to add to all resources"
    type        = map(string)
    default     = {}
}