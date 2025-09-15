#!/bin/bash

set -e

# Variables
PROJECT_NAME="DevOpsProject"
PROJECT_DEST="/opt/$PROJECT_NAME"
SERVICE_FILE="flask-react.service"
SYSTEMD_DEST="/etc/systemd/system/$SERVICE_FILE"
COMPOSE_VERSION="v2.24.6"
USER="user"
GROUP="user"


# Checking permissions
if [ "$EUID" -ne 0 ]; then
    echo "Warning: This script must be run with sudo. Exiting."
    exit 1
fi

# Installing Docker & docker-compose if not installed
if ! command -v docker &> /dev/null; then
    echo "Installing Docker..."
    apt-get update
    apt-get install -y docker.io
    systemctl enable docker
    systemctl start docker
    usermod -aG docker $USER
else
    echo "Docker is already installed"
fi

if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo "Installing Docker Compose..."
    curl -L "https://github.com/docker/compose/releases/download/$COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/bin/docker-compose
    chmod +x /usr/bin/docker-compose
else
    echo "Docker Compose is already installed"
fi

# Moving Exec to /opt/
echo "Copying project to $PROJECT_DEST..."
mkdir -p "$PROJECT_DEST"
cp -r ./* "$PROJECT_DEST"
chown -R $USER:$GROUP "$PROJECT_DEST"
chmod -R u+rwX "$PROJECT_DEST"


if [ -f "$PROJECT_DEST/$SERVICE_FILE" ]; then
    echo "Moving $SERVICE_FILE to $SYSTEMD_DEST..."
    mv "$PROJECT_DEST/$SERVICE_FILE" "$SYSTEMD_DEST"
    chmod 644 "$SYSTEMD_DEST"
else
    echo "Error: $SERVICE_FILE not found in $PROJECT_DEST"
    exit 1
fi

# Changing WORKDIR
echo "Updating WorkingDirectory in $SYSTEMD_DEST..."
sed -i "s|WorkingDirectory=.*|WorkingDirectory=$PROJECT_DEST|" "$SYSTEMD_DEST"

# Reloading systemd daemons
echo "Reloading systemd and starting $SERVICE_FILE..."
systemctl daemon-reload
systemctl enable "$SERVICE_FILE"
systemctl start "$SERVICE_FILE"


echo "Checking service status..."
systemctl status "$SERVICE_FILE" --no-pager

# Verifying result
echo "Verifying application..."
sleep 5
if curl -s http://localhost:5000/profile > /dev/null; then
    echo "Backend is running at http://localhost:5000/profile"
else
    echo "Error: Backend not responding at http://localhost:5000/profile"
    exit 1
fi
if curl -s http://localhost:3000 > /dev/null; then
    echo "Frontend is running at http://localhost:3000"
else
    echo "Error: Frontend not responding at http://localhost:3000"
    exit 1
fi

echo "Deployment completed successfully!"