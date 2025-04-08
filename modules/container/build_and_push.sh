#!/bin/bash
# container/build_and_push.sh

set -e

if [ -z "$1" ]; then
  echo "Usage: $0 <aws_account_id>"
  exit 1
fi

AWS_ACCOUNT_ID=$1
REGION="us-east-1"
REPO_NAME="firehose-producer"
IMAGE_TAG="latest"

ECR_URI="$AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPO_NAME"

# Create ECR repo if it doesn't exist
echo "Creating ECR repo (if not exists)..."
aws ecr describe-repositories --repository-names $REPO_NAME --region $REGION >/dev/null 2>&1 || \
aws ecr create-repository --repository-name $REPO_NAME --region $REGION

# Build Docker image
echo "Building Docker image..."
docker build -t $REPO_NAME ./

docker tag $REPO_NAME:latest $ECR_URI:$IMAGE_TAG

# Authenticate Docker to ECR
echo "Authenticating Docker to ECR..."
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com

# Push to ECR
echo "Pushing Docker image to ECR..."
docker push $ECR_URI:$IMAGE_TAG

echo "Image pushed: $ECR_URI:$IMAGE_TAG"
