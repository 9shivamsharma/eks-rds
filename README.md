# Save Hobby to RDS - Kubernetes Application

A full-stack application that saves user hobbies to AWS RDS MySQL database, deployed on Kubernetes.

## 🏗️ Architecture

- **Frontend**: React.js with Nginx (LoadBalancer)
- **Backend**: Node.js with Express (ClusterIP)
- **Database**: AWS RDS MySQL
- **Deployment**: Kubernetes with Docker containers

## 📁 Project Structure

```
.
├── app-demo/
│   └── new-app/
│       ├── bk/              # Backend (Node.js)
│       │   ├── index.js     # Main server with MySQL connection pooling
│       │   ├── package.json
│       │   └── Dockerfile
│       └── ft/              # Frontend (React)
│           ├── src/
│           │   ├── App.js   # Main React component
│           │   └── index.js
│           ├── public/
│           ├── package.json
│           ├── nginx.conf   # Nginx config with API proxy
│           └── Dockerfile
├── backend-deployment.yaml     # Backend Kubernetes deployment
├── backend-service.yaml        # Backend service (ClusterIP)
├── frontend-deployment.yaml    # Frontend Kubernetes deployment
├── frontend-service.yaml       # Frontend service (LoadBalancer)
├── db-secret.template.yaml     # Database credentials template
└── kubernetes-deployment-guide.md
```

## 🚀 Features

- **Save Hobbies**: Users can input name and hobby
- **Data Persistence**: Stores data in AWS RDS MySQL
- **Connection Pooling**: Improved MySQL connection handling
- **Error Handling**: Graceful error handling with retry logic
- **Health Checks**: Backend health endpoint with DB status
- **Scalable**: 2 replicas each for frontend and backend

## 🛠️ Setup Instructions

### Prerequisites
- Kubernetes cluster (EKS recommended)
- AWS RDS MySQL instance
- Docker images pushed to registry
- kubectl configured

### 1. Database Setup
```bash
# Create database secret (replace with your credentials)
cp db-secret.template.yaml db-secret.yaml
# Edit db-secret.yaml with base64 encoded values
kubectl apply -f db-secret.yaml
```

### 2. Deploy Application
```bash
# Deploy backend
kubectl apply -f backend-deployment.yaml
kubectl apply -f backend-service.yaml

# Deploy frontend
kubectl apply -f frontend-deployment.yaml
kubectl apply -f frontend-service.yaml
```

### 3. Access Application
```bash
# Get frontend URL
kubectl get service frontend-service
```

## 🔧 Technical Details

### Backend Features
- **Connection Pooling**: MySQL2 pool with 5 connections
- **Prepared Statements**: Secure SQL execution
- **Error Handling**: Connection timeout and retry logic
- **Health Endpoint**: `/health` with database status
- **API Endpoints**:
  - `POST /api/save` - Save hobby data  
  - `GET /api/users` - Get all users
  - `GET /api/count` - Get user count

### Frontend Features
- **React Components**: Modern functional components
- **API Integration**: Axios for HTTP requests
- **Error Handling**: User-friendly error messages
- **Responsive Design**: Clean UI for hobby input

### Database Schema
```sql
CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  hobby VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## 🔍 Troubleshooting

### Common Issues

1. **"Failed to save data"**
   - Check if RDS instance is running
   - Verify security groups allow EKS access
   - Check database credentials in secret

2. **Connection Timeouts**
   - Ensure RDS is in "available" status
   - Check network connectivity from pods
   - Verify security group rules

3. **Pod Crashes**
   - Check pod logs: `kubectl logs <pod-name>`
   - Verify image availability
   - Check resource limits

### Debug Commands
```bash
# Check pod status
kubectl get pods

# Check logs
kubectl logs -l app=backend
kubectl logs -l app=frontend

# Test API directly
kubectl exec -it <frontend-pod> -- curl http://backend-service:5000/health

# Check database connectivity
kubectl exec -it <backend-pod> -- node -e "console.log('DB Host:', process.env.DB_HOST)"
```

## 📊 Monitoring

- **Health Check**: `GET /health` endpoint
- **Pod Status**: Monitor via `kubectl get pods`
- **Database**: Check RDS console for connection metrics
- **LoadBalancer**: Monitor via AWS ELB console

## 🛡️ Security

- Database credentials stored in Kubernetes secrets
- Prepared statements prevent SQL injection
- CORS enabled for cross-origin requests
- Network policies can be added for additional security

## 🎯 Success Criteria

✅ **Working Application**: Data saves successfully to RDS  
✅ **Error Handling**: Graceful handling of connection issues  
✅ **Scalability**: Multiple replicas running smoothly  
✅ **Monitoring**: Health checks and logging in place  

## 📝 Recent Fixes

- **Connection Pooling**: Improved MySQL connection reliability
- **RDS Status**: Fixed issue with stopped database instance
- **Error Messages**: Better user feedback for connection issues
- **Health Checks**: Database connectivity monitoring

---

**Status**: ✅ **Working** - Application successfully saves hobbies to RDS! 