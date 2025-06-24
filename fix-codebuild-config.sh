#!/bin/bash

echo "🔧 Fixing CodeBuild Project Configuration"
echo "=========================================="

# Get the current project configuration
echo "📋 Getting current configuration for 'deployment' project..."
PROJECT_CONFIG=$(aws codebuild batch-get-projects --names deployment --region us-east-1 --query 'projects[0]' --output json 2>/dev/null)

if [ $? -eq 0 ]; then
    echo "✅ Successfully retrieved project configuration"
    
    # Check current buildspec setting
    CURRENT_BUILDSPEC=$(echo $PROJECT_CONFIG | jq -r '.source.buildspec // "buildspec.yml"')
    echo "📋 Current buildspec: $CURRENT_BUILDSPEC"
    
    if [ "$CURRENT_BUILDSPEC" != "buildspec.yml" ]; then
        echo "⚠️  Project is configured to use: $CURRENT_BUILDSPEC"
        echo "🔄 Would you like to update it to use buildspec.yml? (y/n)"
        read -r response
        if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
            echo "🔄 Updating project configuration..."
            
            # Create updated configuration
            UPDATED_CONFIG=$(echo $PROJECT_CONFIG | jq '.source.buildspec = "buildspec.yml"')
            
            # Update the project
            aws codebuild update-project --cli-input-json "$UPDATED_CONFIG" --region us-east-1
            
            if [ $? -eq 0 ]; then
                echo "✅ Successfully updated CodeBuild project to use buildspec.yml"
            else
                echo "❌ Failed to update project configuration"
            fi
        else
            echo "ℹ️  Keeping current configuration"
        fi
    else
        echo "✅ Project is already configured to use buildspec.yml"
    fi
else
    echo "❌ Failed to retrieve project configuration"
    echo "💡 Manual steps to fix:"
    echo "1. Go to AWS Console → CodeBuild → Projects"
    echo "2. Select 'deployment' project"
    echo "3. Click 'Edit' → 'Source'"
    echo "4. Set 'Buildspec name' to 'buildspec.yml'"
    echo "5. Save changes"
fi

echo ""
echo "📋 Current buildspec files in repository:"
ls -la buildspec*.yml 2>/dev/null || echo "No buildspec files found"

echo ""
echo "🎯 Next steps:"
echo "1. Commit and push the buildspec-deploy-simple.yml file"
echo "2. Or update the CodeBuild project to use buildspec.yml"
echo "3. Test the pipeline" 