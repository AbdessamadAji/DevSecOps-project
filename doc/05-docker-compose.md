
# Docker Compose

## Overview

Docker Compose was introduced to define and manage the complete application stack using a single configuration file.

Instead of starting each container manually, Docker Compose orchestrates all application services, networking, storage, and environment configuration through a single command.

This provides a consistent local development environment and prepares the application for later migration to Kubernetes.

---

## Why Docker Compose?

Docker Compose simplifies multi-container applications by providing:

- Centralized service definition
- Automatic network creation
- Service discovery
- Persistent storage
- Environment variable management
- Health checks
- Startup dependency management
- centralizes logs from all containers

---

# Services

The application stack consists of three services.

## PostgreSQL

The PostgreSQL container stores the application data using a persistent Docker volume.

A health check ensures that the database is ready before dependent services start.

<br>

<img width="925" height="349" alt="image" src="https://github.com/user-attachments/assets/08aace90-bbf6-4b47-b81a-8fbef4af878b" />

<br>

---

## Backend

The backend service runs the Spring Boot application.

It connects to PostgreSQL through the internal Docker network and receives its configuration from environment variables defined in the Compose file.

The uploads directory is mounted as a persistent volume to preserve uploaded files across container recreation.

<br>

<img width="664" height="293" alt="image" src="https://github.com/user-attachments/assets/01d12a9a-8d80-4572-ba32-6ebfdb76725a" />


<br>

---

## Frontend

The frontend service serves the production React application through Nginx.

Instead of communicating directly with the backend using browser-specific URLs, requests are forwarded through an Nginx reverse proxy.

This provides a cleaner architecture and keeps the frontend independent from backend network details.

<br>

<img width="453" height="207" alt="image" src="https://github.com/user-attachments/assets/f1037d7a-6233-4230-8147-f001f808d9ad" />


<br>

---

# Networking

Docker Compose automatically creates a private network for the application.

All services communicate using their service names instead of IP addresses.

For example:

- frontend → backend
- backend → postgres

This built-in service discovery removes the need for hardcoded IP addresses.

<br>

<img width="308" height="53" alt="image" src="https://github.com/user-attachments/assets/0286caec-8b80-496a-a4ef-68bd41489ab2" />

<br>

---

# Persistent Storage

Two persistent volumes are used:

- PostgreSQL data
- Uploaded application files

Using Docker volumes ensures that data is preserved even if containers are recreated.

<br>

<img width="192" height="86" alt="image" src="https://github.com/user-attachments/assets/249201da-037f-45bd-bbc8-d848935df75c" />

<br>

---

# Environment Configuration

Application configuration is provided through environment variables.

Sensitive values and service configuration are externalized from the application itself, making the deployment more flexible across different environments.

---

# Health Checks

The PostgreSQL service exposes a health check that verifies database readiness.

The backend service depends on this health status before attempting to establish a database connection.

This avoids startup failures caused by services becoming available at different times.

---

# Reverse Proxy

Nginx acts as a reverse proxy between the frontend and backend.

Frontend API requests are forwarded to the backend service while static assets continue to be served directly by Nginx.

This architecture provides a single entry point for the application and simplifies frontend-backend communication.

<br>

<img width="771" height="413" alt="image" src="https://github.com/user-attachments/assets/9dc3eb99-0605-42a2-878d-27c7c471d220" />

<br>

---

# Summary

At the end of this phase:

- The complete application stack runs using Docker Compose.
- Service discovery is handled automatically.
- Persistent data is stored using Docker volumes.
- Environment configuration is externalized.
- Health checks improve service startup reliability.
- Nginx provides a reverse proxy between the frontend and backend.
