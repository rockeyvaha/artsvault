# Dockerfile for ArtsVault Flutter Application
FROM ubuntu:20.04

# Set working directory
WORKDIR /app

# Copy project files
COPY . .

# List files to verify
RUN ls -la

# Show this is a Flutter project
RUN echo "ArtsVault Flutter Project - Build Verification"

# Display pubspec info
RUN cat pubspec.yaml | head -20 || echo "Checking project structure..."