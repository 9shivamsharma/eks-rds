# Kubernetes Deployment Guide

This directory contains the YAML configuration files for your application running on Kubernetes.

## Files Overview

### Individual Resource Files
- `db-secret.yaml` - Database connection credentials (Secret)
- `backend-deployment.yaml` - Backend application deployment
- `backend-service.yaml` - Backend service (ClusterIP)
- `frontend-deployment.yaml` - Frontend application deployment 
- `frontend-service.yaml` - Frontend service (LoadBalancer)

### Combined File
- `complete-app.yaml` - All resources in a single file

## Application Architecture

```
Internet → LoadBalancer → Frontend Pods (Port 3000)
                            ↓
                         Backend Service → Backend Pods (Port 5000)
                            ↓
                         RDS Database
```

## Current Configuration

- **Frontend**: 2 replicas running on port 3000
- **Backend**: 2 replicas running on port 5000
- **Database**: AWS RDS PostgreSQL
- **Images**: Stored in AWS ECR (381492221394.dkr.ecr.ap-south-1.amazonaws.com)

## Deployment Commands

### Deploy All Resources (Recommended)
```bash
kubectl apply -f complete-app.yaml
```

### Deploy Individual Resources
```bash
kubectl apply -f db-secret.yaml
kubectl apply -f backend-deployment.yaml
kubectl apply -f backend-service.yaml
kubectl apply -f frontend-deployment.yaml
kubectl apply -f frontend-service.yaml
```

## Verification Commands

### Check All Resources
```bash
kubectl get all
```

### Check Secrets
```bash
kubectl get secrets
```

### Check Pod Status
```bash
kubectl get pods
```

### Check Services and LoadBalancer
```bash
kubectl get svc
```

### Get LoadBalancer URL
```bash
kubectl get svc frontend-service -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
```

## Environment Variables

The backend deployment uses the following environment variables from the database secret:
- `DB_HOST` - Database hostname
- `DB_USER` - Database username  
- `DB_PASSWORD` - Database password
- `DB_NAME` - Database name

## Scaling

### Scale Frontend
```bash
kubectl scale deployment frontend --replicas=3
```

### Scale Backend
```bash
kubectl scale deployment backend --replicas=3
```

## Updates

### Update Backend Image
```bash
kubectl set image deployment/backend backend=381492221394.dkr.ecr.ap-south-1.amazonaws.com/backend:new-tag
```

### Update Frontend Image
```bash
kubectl set image deployment/frontend frontend=381492221394.dkr.ecr.ap-south-1.amazonaws.com/app:new-tag
```

## Troubleshooting

### View Pod Logs
```bash
kubectl logs -f deployment/backend
kubectl logs -f deployment/frontend
```

### Describe Resources
```bash
kubectl describe deployment backend
kubectl describe service frontend-service
```

### Check Secret Data (Base64 Decoded)
```bash
kubectl get secret db-secret -o jsonpath='{.data.host}' | base64 --decode
```

## Cleanup

### Delete All Resources
```bash
kubectl delete -f complete-app.yaml
```

### Delete Individual Resources
```bash
kubectl delete deployment frontend backend
kubectl delete service frontend-service backend-service
kubectl delete secret db-secret
``` 