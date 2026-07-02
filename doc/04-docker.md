
# Docker

## Overview

Docker was introduced to package the frontend and backend applications into isolated, portable, and reproducible environments.

Instead of relying on software installed on the host machine, each application runs inside its own container with all required runtime dependencies.

Containerization also prepares the application for orchestration platforms such as Kubernetes.

---

## Why Docker?

Using Docker provides several advantages:

- Consistent execution across different environments
- Isolated runtime environments
- Simplified application deployment
- Reproducible builds
- Easier scalability and orchestration

Each application component is packaged into its own Docker image.

---

# Docker Images

## Backend Image

The backend image is responsible for running the Spring Boot application.

It is built from the executable BootJar generated during the Gradle build process and uses Eclipse Temurin JRE as the runtime environment.

The container starts the application directly using the generated BootJar.

---

## Frontend Image

The frontend image serves the production React application.

Instead of including the application source code, only the optimized production build (`dist/`) is copied into the image and served using Nginx.

This approach produces a lightweight image that only contains the files required at runtime.

---

# Dockerfiles

## Backend Dockerfile

The backend Dockerfile performs the following tasks:

- Uses a pinned Eclipse Temurin JRE base image
- Creates a dedicated non-root user
- Copies the BootJar into the image
- Exposes the application port
- Starts the Spring Boot application

<br>

<img width="683" height="368" alt="image" src="https://github.com/user-attachments/assets/9f702fe5-717c-484f-bb3c-09bfb94ff0e3" />

<br>

---

## Frontend Dockerfile

The frontend Dockerfile performs the following tasks:

- Uses a pinned Nginx base image
- Copies the production build (`dist/`)
- Replaces the default Nginx configuration
- Exposes the HTTP port
- Starts the Nginx server

<br>

<img width="683" height="166" alt="image" src="https://github.com/user-attachments/assets/461bf697-28d8-4fce-be4a-dc3899e175a9" />

<br>
---

# Design Decisions

### Separate Images

The frontend and backend are packaged into separate Docker images.

This allows each service to be built, deployed, and scaled independently.

---

### Non-root User

The backend container runs as a non-root user.

Running containers with limited privileges reduces the potential impact of security vulnerabilities.


### Pinned Base Images

Specific image versions are used instead of floating tags such as `latest`.

Pinned versions improve reproducibility and prevent unexpected changes (due to updates) when rebuilding images.

---

### Production Artifacts Only

The backend image contains only the executable BootJar.

The frontend image contains only the optimized `dist/` directory.

Shipping production artifacts instead of source code reduces the image size and minimizes the runtime environment.

---


# Summary

At the end of this phase:

- The frontend and backend are fully containerized.
- Both images use production-ready artifacts.
- The backend runs as a non-root user.
- Base images are pinned to specific versions.
- The application is ready to be orchestrated using Docker Compose.
