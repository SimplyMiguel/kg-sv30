#!/bin/bash
# Test the production container locally before deploying to Cloud Run

# Clear terminal
clear

# Configuration
IMAGE_NAME="kg-sv30-app-prod"
CONTAINER_NAME="kg-sv30-container-prod"
PORT=8080

# Stop and remove any existing container with the same name
echo "Removing any existing production containers..."
docker rm -f $CONTAINER_NAME 2>/dev/null || true

# Build the production Docker image from Dockerfile
echo "Building production Docker image..."
docker build -t $IMAGE_NAME .

# Start the production container
echo "Starting container in PRODUCTION mode..."
echo "⭐️ The application will be available at: http://localhost:$PORT ⭐️"
echo "This is simulating how your app will run in Google Cloud Run"

# Open browser after 3 seconds
(sleep 3 && open http://localhost:$PORT) &

# Run container with Cloud Run-like environment variables
docker run --rm \
  -p $PORT:$PORT \
  -e PORT=$PORT \
  -e FLASK_ENV=production \
  -e DEBUG=false \
  -e SECRET_KEY="prod-test-secret-key" \
  -e GUNICORN_WORKERS=2 \
  -e GUNICORN_THREADS=4 \
  --name $CONTAINER_NAME \
  $IMAGE_NAME

# The command doesn't return until the container stops
# CTRL+C will stop the container
