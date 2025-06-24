#!/bin/bash

echo "🔧 Updating CodeBuild Project Configuration"
echo "==========================================="

PROJECT_NAME="deployment"
REGION="us-east-1"

echo "📋 Getting current configuration for '$PROJECT_NAME' project..."

# Get the current project configuration
PROJECT_CONFIG=$(aws codebuild batch-get-projects --names $PROJECT_NAME --region $REGION --output json 2>/dev/null)

if [ $? -ne 0 ]; then
    echo "❌ Failed to get project configuration. Please check:"
    echo "   - AWS CLI is configured correctly"
    echo "   - You have permissions to access CodeBuild"
    echo "   - Project '$PROJECT_NAME' exists"
    exit 1
fi

echo "✅ Successfully retrieved project configuration"

# Extract the project configuration and update buildspec
echo "🔄 Updating buildspec configuration..."

# Create updated configuration JSON
UPDATED_CONFIG=$(echo "$PROJECT_CONFIG" | jq --arg project "$PROJECT_NAME" '
.projects[0] | 
{
    name: .name,
    source: (.source | .buildspec = "buildspec.yml"),
    artifacts: .artifacts,
    cache: .cache,
    environment: .environment,
    serviceRole: .serviceRole,
    timeoutInMinutes: .timeoutInMinutes,
    queuedTimeoutInMinutes: .queuedTimeoutInMinutes,
    encryptionKey: .encryptionKey,
    tags: .tags,
    vpcConfig: .vpcConfig,
    badge: .badge,
    logsConfig: .logsConfig,
    fileSystemLocations: .fileSystemLocations,
    buildBatchConfig: .buildBatchConfig
}
')

echo "📋 Updated configuration:"
echo "$UPDATED_CONFIG" | jq '.source'

echo "🔄 Updating CodeBuild project..."
aws codebuild update-project --cli-input-json "$UPDATED_CONFIG" --region $REGION

if [ $? -eq 0 ]; then
    echo "✅ Successfully updated CodeBuild project to use buildspec.yml"
    echo ""
    echo "🎯 Next steps:"
    echo "1. The project now uses buildspec.yml by default"
    echo "2. You can remove buildspec-deploy-simple.yml if you want"
    echo "3. Test the pipeline again"
else
    echo "❌ Failed to update project configuration"
    echo "💡 You may need to update manually in AWS Console:"
    echo "   1. Go to CodeBuild → Projects → deployment"
    echo "   2. Edit → Source → Buildspec name: buildspec.yml"
    echo "   3. Save changes"
fi 