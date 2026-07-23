# DevSecOps Project

A production-oriented DevSecOps project built around a **Bulletin Board Application** running on Kubernetes.

> **Original application source:** [https://github.com/hexlet-components ](https://github.com/hexlet-components/project-devops-deploy) 
> This repository is **not** intended to develop the application itself.
>
> The goal is to transform the original application into a complete **production-like DevSecOps platform** by implementing modern DevOps, Cloud Native, Security, Observability, GitOps, and Backup practices.

---

# Project Objectives

This project demonstrates how a traditional web application can be deployed and managed using modern DevSecOps practices.

Main objectives include:

- Containerization
- Kubernetes deployment
- Secure application deployment
- Infrastructure hardening
- Monitoring & Logging
- GitOps
- Backup strategy
- Production best practices

---

# Technology Stack

| Category | Technologies |
|-----------|--------------|
| Frontend | React |
| Backend | Spring Boot |
| Database | PostgreSQL |
| Object Storage | MinIO |
| Containerization | Docker |
| Orchestration | Kubernetes |
| Ingress | NGINX Ingress Controller |
| Monitoring | Prometheus |
| Dashboards | Grafana |
| Logging | Loki + Promtail |
| GitOps | ArgoCD |
| Backup | Velero + pg_dump |

---

# Repository Structure

```text
.
├── argocd/
├── backup/
├── doc/
├── frontend/
├── gradle/
├── k8s/
└── ...
```

---

# Documentation

The project documentation is organized into multiple sections.

| # | Topic | Description |
|---|-------|-------------|
| 01 | [Project Overview](doc/01-project-overview.md) | Project goals and overall architecture |
| 02 | [Architecture](doc/02-architecture.md) | High-level architecture of the platform |
| 03 | [Build Process](doc/03-build-process.md) | Application build workflow |
| 04 | [Docker](doc/04-docker.md) | Docker images and containerization |
| 05 | [Docker Compose](doc/05-docker-compose.md) | Local development environment |
| 06 | [CI Pipeline](doc/06-ci-pipeline.md) | Continuous Integration using GitHub Actions |
| 07 | [Kubernetes](doc/07-Kubernetes.md) | Kubernetes deployment and resources |
| 08 | [Observability](doc/08-Observability.md) | Prometheus, Grafana, Loki and Promtail |
| 09 | [GitOps](doc/09-GitOps.md) | Continuous Delivery with ArgoCD |
| 10 | [Network Policies](doc/10-NetworkPolicies.md) | Kubernetes network isolation |
| 11 | [RBAC](doc/11-RBAC.md) | Role-Based Access Control |
| 12 | [ResourceQuota](doc/12-ResourceQuota.md) | Namespace resource management |
| 13 | [LimitRange](doc/13-LimitRange.md) | Default resource requests and limits |
| 14 | [PodDisruptionBudget](doc/14-PodDisruptionBudget.md) | High availability during disruptions |
| 15 | [PostgreSQL Backup](doc/15-postgres-backup.md) | Automated database backups using pg_dump |
| 16 | [Velero Backup](doc/16-velero-backup.md) | Kubernetes resource backup with Velero |

---

# Production Features

The project includes several production-oriented features.

## Infrastructure

- Kubernetes Deployments
- Services
- Ingress
- ConfigMaps
- Secrets
- StatefulSets
- Persistent Volumes

## Security

- RBAC
- Service Accounts
- Network Policies
- ResourceQuota
- LimitRange
- PodDisruptionBudget
- Non-root Containers
- Security Hardening

## Observability

- Prometheus
- Grafana
- Loki
- Promtail
- Spring Boot Metrics

## GitOps

- ArgoCD

## Backup

- Velero for Kubernetes resources
- PostgreSQL automated backups using pg_dump
- MinIO as S3-compatible backup storage

---

# Backup Strategy

Instead of relying on a single backup solution, the project follows a layered backup strategy.

| Component | Backup Method |
|-----------|---------------|
| Kubernetes Resources | Velero |
| PostgreSQL | pg_dump |
| Backup Storage | MinIO |

This approach is commonly used in production environments where infrastructure resources and application data are backed up independently.

---

# Acknowledgments

Original application:

[https://github.com/hexlet-components](https://github.com/hexlet-components/project-devops-deploy)

This repository focuses exclusively on the **DevSecOps implementation** and production deployment of the original application.
