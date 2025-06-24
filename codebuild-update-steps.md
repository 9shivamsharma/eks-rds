# CodeBuild Project Update Guide

## Method 1: Using the Script (Recommended)

```bash
# Make the script executable
chmod +x update-codebuild.sh

# Run the script
./update-codebuild.sh
```

## Method 2: Manual AWS CLI Commands

### Step 1: Get Current Configuration
```bash
aws codebuild batch-get-projects --names deployment --region us-east-1 --output json > current-config.json
```

### Step 2: Update the Configuration
Edit the `current-config.json` file and change:
```json
"buildspec": "buildspec-deploy-simple.yml"
```
to:
```json
"buildspec": "buildspec.yml"
```

### Step 3: Update the Project
```bash
aws codebuild update-project --cli-input-json file://current-config.json --region us-east-1
```

## Method 3: Direct Update Command

If you have the full project configuration, you can use:

```bash
aws codebuild update-project \
  --name deployment \
  --source type=CODECOMMIT,location=https://git-codecommit.us-east-1.amazonaws.com/v1/repos/your-repo,buildspec=buildspec.yml \
  --region us-east-1
```

## Method 4: AWS Console (If CLI fails)

1. Go to AWS Console → CodeBuild → Projects
2. Select "deployment" project
3. Click "Edit" → "Source"
4. Change "Buildspec name" to `buildspec.yml`
5. Save changes

## Verification

After updating, verify the change:

```bash
aws codebuild batch-get-projects --names deployment --region us-east-1 --query 'projects[0].source.buildspec' --output text
```

This should return: `buildspec.yml`

## Troubleshooting

If you get permission errors:
- Ensure your AWS credentials have CodeBuild permissions
- Check that you're in the correct AWS region
- Verify the project name is correct

If the update fails:
- Use the AWS Console method as a fallback
- Check the project configuration for any required fields 