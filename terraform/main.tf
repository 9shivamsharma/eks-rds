terraform {
  required_version = ">= 1.0"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

# Frontend Deployment
resource "kubernetes_deployment" "frontend" {
  metadata {
    name      = "frontend"
    namespace = var.namespace
    labels = {
      app = "frontend"
    }
  }

  spec {
    replicas = var.frontend_replicas

    selector {
      match_labels = {
        app = "frontend"
      }
    }

    template {
      metadata {
        labels = {
          app = "frontend"
        }
      }

      spec {
        container {
          image = var.frontend_image
          name  = "frontend"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}

# Backend Deployment
resource "kubernetes_deployment" "backend" {
  metadata {
    name      = "backend"
    namespace = var.namespace
    labels = {
      app = "backend"
    }
  }

  spec {
    replicas = var.backend_replicas

    selector {
      match_labels = {
        app = "backend"
      }
    }

    template {
      metadata {
        labels = {
          app = "backend"
        }
      }

      spec {
        container {
          image = var.backend_image
          name  = "backend"
          port {
            container_port = 5000
          }
          
          env {
            name = "DB_HOST"
            value_from {
              secret_key_ref {
                name = "db-secret"
                key  = "host"
              }
            }
          }
          
          env {
            name = "DB_USER"
            value_from {
              secret_key_ref {
                name = "db-secret"
                key  = "username"
              }
            }
          }
          
          env {
            name = "DB_PASSWORD"
            value_from {
              secret_key_ref {
                name = "db-secret"
                key  = "password"
              }
            }
          }
          
          env {
            name = "DB_NAME"
            value_from {
              secret_key_ref {
                name = "db-secret"
                key  = "dbname"
              }
            }
          }
        }
      }
    }
  }
}

# Frontend Service
resource "kubernetes_service" "frontend" {
  metadata {
    name      = "frontend-service"
    namespace = var.namespace
  }

  spec {
    selector = {
      app = "frontend"
    }

    port {
      port        = 80
      target_port = 80
      protocol    = "TCP"
    }

    type = "LoadBalancer"
  }
}

# Backend Service
resource "kubernetes_service" "backend" {
  metadata {
    name      = "backend-service"
    namespace = var.namespace
  }

  spec {
    selector = {
      app = "backend"
    }

    port {
      port        = 5000
      target_port = 5000
      protocol    = "TCP"
    }

    type = "ClusterIP"
  }
}

# Outputs
output "frontend_service_ip" {
  description = "Frontend service external IP"
  value       = kubernetes_service.frontend.status.0.load_balancer.0.ingress.0.ip
}

output "backend_service_cluster_ip" {
  description = "Backend service cluster IP"
  value       = kubernetes_service.backend.spec.0.cluster_ip
} 