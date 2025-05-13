#!/bin/bash
# Stop script for Knowledge Graph Docker container
# This script removes EVERYTHING - container, image, volumes, etc.

clear

# Set container name for easy reference
CONTAINER_NAME="kg-sv30-container-dev"
IMAGE_NAME="kg-sv30-app-dev"

echo "Stopping any running containers..."
docker stop $(docker ps -q --filter "name=$CONTAINER_NAME") 2>/dev/null || true

echo "Removing any stopped containers..."
docker rm $(docker ps -a -q --filter "name=$CONTAINER_NAME") 2>/dev/null || true

echo "Removing Docker image..."
docker rmi $IMAGE_NAME 2>/dev/null || true

echo "Removing dangling images related to this project..."
docker image prune -f

echo "Removing anonymous volumes not used by any containers..."
docker volume prune -f

echo "Removing unused networks..."
docker network prune -f

echo "Nuclear option complete. All Docker resources for $CONTAINER_NAME have been removed."
