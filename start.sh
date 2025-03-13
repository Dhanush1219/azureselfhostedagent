#!/bin/bash
set -e

# Ensure required environment variables are set
: "${AZP_URL:?Environment variable AZP_URL is required}"
: "${AZP_TOKEN:?Environment variable AZP_TOKEN is required}"
: "${AZP_POOL:?Environment variable AZP_POOL is required}"

# Set working directory
cd /azp/agent

# Set a default agent name if not provided
AZP_AGENT_NAME="${AZP_AGENT_NAME:-$(hostname)}"

echo "Fixing Docker socket permissions..."
sudo chmod 666 /var/run/docker.sock || echo "Warning: Could not change Docker socket permissions"

echo "Starting Docker service..."
sudo service docker start

# Wait for Docker to be ready
until docker info >/dev/null 2>&1; do
    echo "Waiting for Docker to start..."
    sleep 3
done
echo "Docker is running."

# Configure and start the Azure DevOps agent
./config.sh --unattended --url "$AZP_URL" --auth PAT --token "$AZP_TOKEN" --pool "$AZP_POOL" --agent "$AZP_AGENT_NAME" --replace

# Run the agent in the foreground
./run.sh

# Keep the container running
wait

