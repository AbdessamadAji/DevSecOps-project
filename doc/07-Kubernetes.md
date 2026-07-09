# Kubernetes

## Overview

Kubernetes was introduced to replace Docker Compose and provide a production-oriented deployment platform.

While Docker Compose is well suited for local development, it lacks features such as self-healing, rolling updates, resource management, and advanced traffic routing.

Migrating the application to Kubernetes allowed every component to be deployed independently while improving scalability, reliability, and maintainability.

---

## Namespace

A dedicated namespace named `bulletin` isolates all project resources from the rest of the cluster.

Using a separate namespace improves organization, simplifies resource management, and prevents conflicts with workloads running in the default namespace.

All application resources, including Deployments, Services, Secrets, ConfigMaps, and PersistentVolumeClaims, are deployed inside this namespace.


<img width="826" height="192" alt="image" src="https://github.com/user-attachments/assets/bcbb5137-44fb-46d8-a456-20c75c0ca5d6" />

<br>

---

## Application Components

Each application component is deployed independently to simplify scaling, updates, and fault isolation.

The application is deployed as four independent workloads.

### Frontend

The frontend is deployed as two replicated Pods running Nginx, which serves the production React application.

Configuration is externalized through a ConfigMap containing the Nginx configuration, while a ClusterIP Service exposes the application internally.


<img width="826" height="131" alt="image" src="https://github.com/user-attachments/assets/6675bcb8-bdf6-4b15-9629-52000139bdf8" />

<br>

---

### Backend

The backend runs as a Spring Boot Deployment with two replicas to improve availability.

Application configuration is provided through ConfigMaps, while sensitive values such as database and MinIO credentials are injected using Kubernetes Secrets.

The backend communicates with PostgreSQL for relational data and MinIO for object storage.


<img width="826" height="169" alt="image" src="https://github.com/user-attachments/assets/519f6330-fc08-4833-b4ba-80eb886d52f2" />

<br>

---

### PostgreSQL

PostgreSQL is deployed using a StatefulSet instead of a Deployment because database workloads require persistent identities and stable storage.

A Headless Service provides stable network identities, while a PersistentVolumeClaim ensures that the database survives Pod recreation.

Unlike stateless applications, databases require stable storage and network identities, making StatefulSets a better choice than Deployments.

<img width="826" height="132" alt="image" src="https://github.com/user-attachments/assets/bbfe7a4d-8a34-42de-8ab5-14b42efd41b7" />

<br>

---

### MinIO

MinIO is deployed as an object storage service responsible for storing uploaded images.

Only image keys are stored in PostgreSQL, while the actual files are persisted inside MinIO using a dedicated PersistentVolumeClaim.

This keeps the database lightweight by storing only image references instead of binary files.

<img width="826" height="192" alt="image" src="https://github.com/user-attachments/assets/ff87140b-c5a4-4b1e-8b23-4f2652d7b3c2" />

<br>

---

## Service Discovery

Each application component is exposed internally using a ClusterIP Service.

Instead of communicating through Pod IP addresses, services communicate using Kubernetes DNS names such as `backend-service`, `postgres-service`, and `minio-service`.

This allows Pods to be recreated without affecting communication between application components.

For example, the backend connects to PostgreSQL using `postgres-service` instead of a Pod IP address.

<img width="899" height="150" alt="image" src="https://github.com/user-attachments/assets/c8e0ab82-8522-4664-82ed-c596abdfb72e" />

<br>

---

## Configuration Management

Application configuration is separated from the container images.

ConfigMaps store non-sensitive configuration such as application settings and the Nginx configuration, while Secrets securely provide database credentials and MinIO access keys to the application.

This approach makes deployments more portable and easier to manage across environments.

<img width="924" height="134" alt="image" src="https://github.com/user-attachments/assets/b19cae0e-2faa-46ca-b4ac-380854e3be20" />

<br>

---

## Persistent Storage

PersistentVolumeClaims are used for both PostgreSQL and MinIO.

This ensures that database records and uploaded images remain available even if their Pods are deleted or recreated.

Without persistent storage, all application data would be lost whenever a container is replaced.

<img width="1920" height="203" alt="image" src="https://github.com/user-attachments/assets/ea7b86ef-858c-4efb-b5c5-9258953a39b1" />

<br>

---

## Ingress

An NGINX Ingress provides a single entry point for the application.

Incoming requests are routed according to their URL path:

- `/` → Frontend
- `/api` → Backend REST API
- `/minio` → MinIO Object Storage

This removes the need to expose every service individually while providing a cleaner and more maintainable architecture.

<img width="915" height="112" alt="image" src="https://github.com/user-attachments/assets/6e25420a-0d0b-4f99-92f6-05944f3e63b7" />

<br>

---

## Resource Management

CPU and memory requests and limits are defined for every workload.

Requests guarantee the minimum resources required for a Pod to start, while limits prevent a single container from consuming excessive cluster resources.

This improves cluster stability and ensures fair resource allocation.

Without resource limits, a single container could consume excessive CPU or memory and negatively affect other workloads running in the cluster.

<img width="529" height="167" alt="image" src="https://github.com/user-attachments/assets/d3626890-72f9-432e-84a2-f3816f31a9af" />

<br>

---

## Health Checks

Liveness and readiness probes are used to monitor application health.

Readiness probes prevent traffic from reaching Pods before they are fully initialized, while liveness probes allow Kubernetes to restart unhealthy containers automatically.

Probe timing should be configured carefully, as aggressive values may cause unnecessary container restarts during application startup.

<img width="843" height="448" alt="image" src="https://github.com/user-attachments/assets/1fa4d827-6552-437a-b390-9277a6c17a69" />

<br>

---

## Security

Basic Kubernetes security practices were applied throughout the deployment.

Containers run with restricted security contexts by disabling privilege escalation, dropping Linux capabilities, and using the default seccomp profile whenever possible.

Sensitive configuration is managed through Kubernetes Secrets instead of being embedded inside container images.

These settings reduce the container attack surface and follow Kubernetes security best practices.

<img width="582" height="267" alt="image" src="https://github.com/user-attachments/assets/60e86e0a-4226-40d3-ad42-73328ad2d27f" />

<br>

---

## Summary

The migration from Docker Compose to Kubernetes transformed the application into a production-oriented deployment.

Key improvements include:

- Isolated workloads using a dedicated namespace
- Independent deployments for each application component
- Internal service discovery through ClusterIP Services
- Externalized configuration using ConfigMaps and Secrets
- Persistent storage for PostgreSQL and MinIO
- Centralized traffic routing using Ingress
- Resource management and container health monitoring
- Improved security through Kubernetes security contexts
