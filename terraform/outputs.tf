output "frontend_service_ip" {
  description = "Frontend service external IP"
  value       = kubernetes_service.frontend.status.0.load_balancer.0.ingress.0.ip
}

output "backend_service_cluster_ip" {
  description = "Backend service cluster IP"
  value       = kubernetes_service.backend.spec.0.cluster_ip
}

output "frontend_deployment_name" {
  description = "Frontend deployment name"
  value       = kubernetes_deployment.frontend.metadata.0.name
}

output "backend_deployment_name" {
  description = "Backend deployment name"
  value       = kubernetes_deployment.backend.metadata.0.name
}

output "frontend_service_name" {
  description = "Frontend service name"
  value       = kubernetes_service.frontend.metadata.0.name
}

output "backend_service_name" {
  description = "Backend service name"
  value       = kubernetes_service.backend.metadata.0.name
} 