variable "frontend_image" {
  description = "Frontend Docker image"
  type        = string
  default     = "605134461257.dkr.ecr.us-east-1.amazonaws.com/frontend:latest"
}

variable "backend_image" {
  description = "Backend Docker image"
  type        = string
  default     = "605134461257.dkr.ecr.us-east-1.amazonaws.com/backend:latest"
}

variable "frontend_replicas" {
  description = "Number of frontend replicas"
  type        = number
  default     = 2
}

variable "backend_replicas" {
  description = "Number of backend replicas"
  type        = number
  default     = 2
}

variable "namespace" {
  description = "Kubernetes namespace"
  type        = string
  default     = "default"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
} 