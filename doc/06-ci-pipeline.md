# CI Pipeline

## Overview

Continuous Integration (CI) was introduced to automatically validate every code change before it becomes part of the project.

Instead of manually building, testing, and scanning the application, GitHub Actions performs these tasks automatically whenever code is pushed or a Pull Request is opened.

This ensures that every change is verified using the same reproducible workflow.

---

## Why Continuous Integration?

The CI pipeline provides several benefits:

- Automated application builds
- Automated testing
- Early bug detection
- Continuous security scanning
- Consistent build environment
- Faster developer feedback
- Production-ready build artifacts

---

# CI Architecture

The pipeline is executed inside a fresh GitHub-hosted Ubuntu runner.

A temporary PostgreSQL container is started for backend tests, while GitHub Actions executes each stage of the workflow.

<br>

<img width="1024" height="1536" alt="image" src="https://github.com/user-attachments/assets/06c518df-932f-45a1-8a41-98416391dafc" />


<br>



---

# Pipeline Trigger

The workflow starts automatically when:

- Code is pushed to the **main** branch.
- A Pull Request is created or updated.

Running the pipeline on every change helps detect problems before they reach production.

---


# GitHub Permissions

The workflow follows the principle of least privilege.

Only the permissions required by the pipeline are granted.

This limits the impact of a compromised workflow and improves overall security.

---

# GitHub Runner

Every workflow runs inside a clean Ubuntu virtual machine provided by GitHub.

Using a fresh environment for every execution guarantees reproducible builds and avoids interference from previous pipeline runs.

---

# PostgreSQL Service

The backend requires a PostgreSQL database during testing.

GitHub Actions automatically starts a PostgreSQL container before executing the workflow.

A health check verifies that the database is ready before backend tests begin.

---

# Repository Checkout

The first step downloads the project source code into the runner.

The complete Git history is also fetched because Gitleaks analyzes previous commits when searching for leaked secrets.

---

# Environment Setup

Two development environments are prepared.

## Java

Java 21 is installed for the Spring Boot backend.

Gradle dependencies are cached to reduce build time.

---

## Node.js

Node.js is installed for the React frontend.

The npm cache is restored using the package-lock file to speed up dependency installation.

---

# Dependency Caching

Gradle and npm caches are restored automatically.

Caching avoids downloading dependencies during every pipeline execution, significantly reducing build time.


---

# Dependency Installation

Frontend dependencies are installed using:

- npm ci

Unlike npm install, npm ci installs the exact versions stored in package-lock.json, providing deterministic builds that are ideal for CI environments.

---

# Code Quality

Before building the application, ESLint analyzes the frontend source code.

Linting detects coding mistakes, inconsistent formatting, and potential programming errors before they become larger issues.

---

# Security Scanning

Security validation is integrated throughout the pipeline.

## Secret Scanning

Gitleaks searches the repository and Git history for accidentally committed secrets such as:

- API Keys
- Passwords
- Access Tokens
- Private Keys

This helps prevent sensitive information from reaching the repository.

---

## Static Application Security Testing (SAST)

Semgrep performs static analysis on the source code without executing the application.

It searches for insecure coding patterns and common vulnerabilities such as:

- Injection risks
- Unsafe APIs
- Insecure coding practices

---

## Filesystem Scan

Trivy scans the project filesystem before Docker images are built.

This scan detects vulnerable dependencies, configuration issues, and other security risks present in the project files.

---

# Backend Testing

The backend unit tests are executed using Gradle.

Running tests before building ensures that application functionality remains correct after every code change.

---

# Application Build

Once validation succeeds, production artifacts are generated.

Backend:

- Spring Boot executable JAR

Frontend:

- Optimized React production build

These artifacts represent the deployable version of the application.

---

# Build Artifacts

GitHub Actions stores the generated artifacts after a successful build.

The uploaded artifacts are the exact files later used to build Docker images or deploy the application.
---

# Application Startup

The generated Spring Boot application is started inside the CI runner.

This prepares the environment for dynamic security testing.

---

# Health Check

Before security testing begins, the pipeline continuously checks the application's health endpoint.

Only after the backend reports a healthy status does the workflow continue.

This avoids failures caused by services starting at different speeds.

---

# Dynamic Application Security Testing (DAST)

OWASP ZAP performs dynamic security testing against the running application.

Unlike static analysis, DAST interacts with the live application and searches for common web security issues from an attacker's perspective.

---

# Docker Image Build

After the application has passed all previous validation stages, Docker images are built for both the backend and frontend.

Building images inside CI guarantees that container images are always produced from verified source code.

---

# Container Image Scanning

Trivy scans the generated Docker images for known vulnerabilities.

This includes:

- Operating system packages
- Installed libraries
- Known CVEs

Scanning container images adds an additional security layer before publication.

---

# Docker Hub

Docker images are pushed to Docker Hub only when:

- The workflow was triggered by a push
- The push targets the main branch

Pull Requests execute the complete validation pipeline without publishing images.

This prevents unreviewed code from being distributed.

Publishing images only from the main branch ensures that only reviewed and validated code becomes available for deployment.

---

# Pipeline Flow

<br>

<img width="759" height="1600" alt="image" src="https://github.com/user-attachments/assets/bdff82e6-a9c9-44d6-a6fe-7c4820e43a6a" />

<br>

---

# Summary

At the end of this phase:

- Every code change is automatically validated.
- Frontend code quality is enforced.
- Secrets are detected before deployment.
- Static and dynamic security testing are integrated.
- Backend functionality is verified through automated tests.
- Production artifacts are generated automatically.
- Docker images are scanned before publication.
- Verified images are automatically published to Docker Hub.
