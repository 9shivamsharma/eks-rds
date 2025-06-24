#!/bin/bash

echo "🔍 Checking EKS permissions for CodeBuild..."

# Get the CodeBuild service role name
echo "📋 Finding CodeBuild service role..."
CODEBUILD_ROLE=$(aws codebuild list-projects --query 'projects[0]' --output text 2>/dev/null)
if [ -n "$CODEBUILD_ROLE" ]; then
    echo "Found CodeBuild project: $CODEBUILD_ROLE"
    ROLE_ARN=$(aws codebuild batch-get-projects --names $CODEBUILD_ROLE --query 'projects[0].serviceRole' --output text 2>/dev/null)
    echo "Service role ARN: $ROLE_ARN"
    
    # Extract role name from ARN
    ROLE_NAME=$(echo $ROLE_ARN | sed 's/.*role\///')
    echo "Role name: $ROLE_NAME"
else
    echo "❌ Could not find CodeBuild project"
    exit 1
fi

# Check current policies
echo "📋 Current policies on $ROLE_NAME:"
aws iam list-attached-role-policies --role-name $ROLE_NAME

# Check if EKS policy exists
echo "🔍 Checking for EKS permissions..."
EKS_POLICY=$(aws iam list-attached-role-policies --role-name $ROLE_NAME --query "AttachedPolicies[?PolicyName=='CodeBuildEKSDeployPolicy'].PolicyArn" --output text)

if [ -z "$EKS_POLICY" ]; then
    echo "❌ EKS permissions not found. Adding them..."
    
    # Create EKS policy
    cat > eks-policy.json << EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "eks:DescribeCluster",
                "eks:ListClusters",
                "eks:AccessKubernetesApi"
            ],
            "Resource": "*"
        }
    ]
}
EOF
    
    # Create and attach policy
    aws iam create-policy \
        --policy-name CodeBuildEKSDeployPolicy \
        --policy-document file://eks-policy.json
    
    POLICY_ARN=$(aws iam list-policies --query "Policies[?PolicyName=='CodeBuildEKSDeployPolicy'].Arn" --output text)
    
    aws iam attach-role-policy \
        --role-name $ROLE_NAME \
        --policy-arn $POLICY_ARN
    
    echo "✅ EKS permissions added!"
else
    echo "✅ EKS permissions already exist"
fi

# Check EKS cluster status
echo "🔍 Checking EKS cluster status..."
aws eks describe-cluster --name eks-cluster-new --region us-east-1 --query 'cluster.status' --output text

echo "✅ Permission check completed!" 