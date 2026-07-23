
# Project Overview

## Introduction

This project transforms an existing Spring Boot and React application into a production-like DevSecOps platform.
The application is a web platform for managing and publishing bulletins through a modern React frontend and a Spring Boot REST API.

<br>

<img width="1920" height="1005" alt="image" src="https://github.com/user-attachments/assets/6241ec79-0c40-4133-961b-68976beb414b" />

<br>
<br>

The objective is not only to containerize and deploy the application, but also to implement modern DevSecOps practices including CI/CD, security scanning, Kubernetes orchestration, monitoring, and GitOps using open-source technologies.

---

## Objectives

The main objectives of this project are:

- Understand the application architecture before deployment.
- Containerize the application using Docker.
- Orchestrate services using Docker Compose.
- Build a secure CI pipeline.
- Integrate security scanning tools.
- Deploy the application to Kubernetes.
- Package Kubernetes resources using Helm.
- Monitor the platform using Prometheus, Grafana, Loki and Promtail.
- Implement GitOps with ArgoCD.
- Follow production-oriented DevSecOps practices throughout the project.

---

## Technology Stack

### Frontend

- React
- React Admin
- TypeScript
- Vite
- Material UI
- Nginx

### Backend

- Spring Boot
- Java 21
- Gradle
- Spring Security
- Spring Boot Actuator
- Micrometer

### Database

- PostgreSQL

### Object Storage

- MinIO

### DevSecOps

- Git
- GitHub
- Docker
- Docker Compose
- GitHub Actions
- Gitleaks
- OWASP Dependency Check
- SonarQube Community
- Trivy
- Kubernetes
- Helm
- NGINX Ingress Controller
- ArgoCD
- RBAC
- Network Policies
- ResourceQuota
- LimitRange
- PodDisruptionBudget
- Velero

### Monitoring & Logging

- Prometheus
- Grafana
- Loki
- Promtail

### Backup

- Velero
- pg_dump
- MinIO Client (mc)
- Kubernetes CronJobs

---

## Project Architecture

The application follows a three-tier architecture.

- React frontend served by Nginx
- Spring Boot REST API
- PostgreSQL database

The frontend communicates with the backend through a reverse proxy, while the backend manages business logic, persistence, and file storage.

A more detailed architecture is available in **02-architecture.md**.


---

## Acknowledgments

The original application was developed by **hexlet-components**.

This project focuses on transforming the application into a production-oriented DevSecOps platform by implementing containerization, CI/CD, security, Kubernetes, monitoring, and GitOps practices.

Original project:
https://github.com/hexlet-components/project-devops-deploy
