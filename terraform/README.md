# Terraform Kubernetes Deployment

This directory contains Terraform configuration for deploying the frontend and backend applications to Kubernetes.

## Benefits of Terraform Approach

1. **Infrastructure as Code**: All infrastructure is version-controlled and declarative
2. **State Management**: Terraform tracks the state of your infrastructure
3. **Consistency**: Ensures deployments are consistent across environments
4. **Rollback Capability**: Easy to rollback to previous states
5. **Better Integration**: Native AWS provider integration

## Files Structure

- `main.tf` - Main Terraform configuration with Kubernetes resources
- `variables.tf` - Variable definitions
- `outputs.tf` - Output values
- `terraform.tfvars` - Environment-specific variable values

## Usage

### Local Development
```bash
cd terraform
terraform init
terraform plan
terraform apply
```

### In CodeBuild Pipeline
Use the `buildspec-terraform.yml` file which:
1. Installs Terraform
2. Initializes the Terraform configuration
3. Plans the deployment
4. Applies the changes
5. Waits for rollouts to complete

## Key Differences from Direct kubectl

| Aspect | Direct kubectl | Terraform |
|--------|----------------|-----------|
| **Approach** | Imperative | Declarative |
| **State Tracking** | None | Built-in |
| **Version Control** | Limited | Full |
| **Rollback** | Manual | Automated |
| **Consistency** | Error-prone | Guaranteed |

## Variables

- `frontend_image`: Docker image for frontend
- `backend_image`: Docker image for backend
- `frontend_replicas`: Number of frontend replicas
- `backend_replicas`: Number of backend replicas
- `namespace`: Kubernetes namespace
- `aws_region`: AWS region

## Outputs

- `frontend_service_ip`: External IP of frontend service
- `backend_service_cluster_ip`: Cluster IP of backend service
- Deployment and service names for reference

## Migration from kubectl

To migrate from your current kubectl-based deployment:

1. Replace `buildspec.yml` with `buildspec-terraform.yml`
2. Copy the terraform directory to your project
3. Update the image variables in `terraform.tfvars`
4. Run the pipeline

The Terraform approach will create the same resources but with better state management and consistency. 