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

<img width="297" height="108" alt="image" src="https://github.com/user-attachments/assets/77e8f023-6c47-405c-9a26-f0716b5388f0" />

<br>

---

# GitHub Secrets

Sensitive information should never be stored directly in the repository or hardcoded inside the CI workflow.

GitHub Secrets provides a secure way to store confidential values such as credentials, access tokens, and passwords. During pipeline execution, these secrets are injected into the workflow as environment variables, allowing jobs to authenticate with external services without exposing sensitive information.

Using GitHub Secrets improves security while keeping the pipeline portable and easy to configure across different environments.

<img width="962" height="598" alt="image" src="https://github.com/user-attachments/assets/8c5e99e2-6a85-4cc7-93b2-e342cbf4bec3" />

<br>

---

# GitHub Runner

Every workflow runs inside a clean Ubuntu virtual machine provided by GitHub.

Using a fresh environment for every execution guarantees reproducible builds and avoids interference from previous pipeline runs.


---

# PostgreSQL Service

The backend requires a PostgreSQL database during testing.

GitHub Actions automatically starts a PostgreSQL container before executing the workflow.

A health check verifies that the database is ready before backend tests begin.

<img width="680" height="307" alt="image" src="https://github.com/user-attachments/assets/a1e24301-b230-4c58-ae59-9e9ef5f225be" />

<br>

---

# Repository Checkout

The first step downloads the project source code into the runner.

The complete Git history is also fetched because Gitleaks analyzes previous commits when searching for leaked secrets.

<img width="706" height="133" alt="image" src="https://github.com/user-attachments/assets/d6df6e6a-6935-4032-9cbe-f5a7464aa5fa" />

<br>

---

# Environment Setup

Two development environments are prepared.

## Java

Java 21 is installed for the Spring Boot backend.

Gradle dependencies are cached to reduce build time.

<img width="455" height="152" alt="image" src="https://github.com/user-attachments/assets/374badf4-1899-4192-bda0-f564c9e9cda6" />

<br>

---

## Node.js

Node.js is installed for the React frontend.

The npm cache is restored using the package-lock file to speed up dependency installation.

<img width="585" height="147" alt="image" src="https://github.com/user-attachments/assets/4370163c-2709-4ab1-ab90-cf6552954579" />

<br>

---

# Dependency Caching

Gradle and npm caches are restored automatically.

Caching avoids downloading dependencies during every pipeline execution, significantly reducing build time.


---

# Dependency Installation

Frontend dependencies are installed using:

- npm ci

Unlike npm install, npm ci installs the exact versions stored in package-lock.json, providing deterministic builds that are ideal for CI environments.

The backend does not require a dedicated dependency installation step. Gradle automatically downloads and manages all required dependencies when executing the build.

<img width="373" height="99" alt="image" src="https://github.com/user-attachments/assets/b2083406-b318-421a-bac2-d22e44438082" />

<br>

---

# Code Quality

Before building the application, ESLint analyzes the frontend source code.

Linting detects coding mistakes, inconsistent formatting, and potential programming errors before they become larger issues.

<img width="373" height="99" alt="image" src="https://github.com/user-attachments/assets/526918e9-3234-4abb-9286-ca80689b33fa" />

<br>

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

<img width="527" height="170" alt="image" src="https://github.com/user-attachments/assets/9cb7f205-186c-4b92-9113-10e0660c8b15" />

<br>

---

## Static Application Security Testing (SAST)

Semgrep performs static analysis on the source code without executing the application.

It searches for insecure coding patterns and common vulnerabilities such as:

- Injection risks
- Unsafe APIs
- Insecure coding practices

<img width="422" height="147" alt="image" src="https://github.com/user-attachments/assets/61a1b7b7-4bc8-4365-89a8-f37d105815e5" />

<br>

---

## Filesystem Scan

Trivy scans the project filesystem before Docker images are built.

This scan detects vulnerable dependencies, configuration issues, and other security risks present in the project files.

<img width="691" height="223" alt="image" src="https://github.com/user-attachments/assets/43a840df-ad04-4735-b372-37eb6b1f37f2" />

<br>

---

# Backend Testing

The backend unit tests are executed using Gradle.

Running tests before building ensures that application functionality remains correct after every code change.

<img width="336" height="160" alt="image" src="https://github.com/user-attachments/assets/ff45f13d-baa9-490f-a962-cec6b0cc91a7" />

<br>

---

# Application Build

Once validation succeeds, production artifacts are generated.

Backend:

- Spring Boot executable JAR

Frontend:

- Optimized React production build

These artifacts represent the deployable version of the application.

<img width="359" height="238" alt="image" src="https://github.com/user-attachments/assets/38fa12ec-6418-4264-a760-2640b6c8a45b" />

<br>

---

# Build Artifacts

GitHub Actions stores the generated artifacts after a successful build.

The uploaded artifacts are the exact files later used to build Docker images or deploy the application.

<img width="359" height="314" alt="image" src="https://github.com/user-attachments/assets/5c92c1e5-1fb8-49b4-94a3-dc3fc2885b79" />

<br>

---

# Application Startup

The generated Spring Boot application is started inside the CI runner.

This prepares the environment for dynamic security testing.

<img width="573" height="164" alt="image" src="https://github.com/user-attachments/assets/972fbbe7-0b26-418e-a762-3b1c3d05b976" />

<br>

---

# Health Check

Before security testing begins, the pipeline continuously checks the application's health endpoint.

Only after the backend reports a healthy status does the workflow continue.

This avoids failures caused by services starting at different speeds.

<img width="656" height="382" alt="image" src="https://github.com/user-attachments/assets/70d3c5a8-3109-4a08-ae7b-c57306a7eeed" />

<br>

---

# Dynamic Application Security Testing (DAST)

OWASP ZAP performs dynamic security testing against the running application.

Unlike static analysis, DAST interacts with the live application and searches for common web security issues from an attacker's perspective.

<img width="741" height="181" alt="image" src="https://github.com/user-attachments/assets/92854779-fbc8-4bb5-aa77-1137ae89a0be" />

<br>

---

# Docker Image Build

After the application has passed all previous validation stages, Docker images are built for both the backend and frontend.

Building images inside CI guarantees that container images are always produced from verified source code.

<img width="741" height="236" alt="image" src="https://github.com/user-attachments/assets/a3d37f5f-2640-4b7d-a116-36fd07195a1a" />

<br>

---

# Container Image Scanning

Trivy scans the generated Docker images for known vulnerabilities.

This includes:

- Operating system packages
- Installed libraries
- Known CVEs

Scanning container images adds an additional security layer before publication.

For demonstration purposes, the pipeline is configured to continue even if OWASP ZAP reports security findings by forcing the step to exit with code `0`. This prevents the scan from failing the CI 
pipeline while the project is under development. In a production environment, the pipeline should fail when vulnerabilities exceeding the accepted security threshold are detected.


<img width="761" height="405" alt="image" src="https://github.com/user-attachments/assets/5e6eb56a-038b-4ac9-b1b7-9a5230f02a85" />

<br>

---

# Docker Hub

Docker images are pushed to Docker Hub only when:

- The workflow was triggered by a push
- The push targets the main branch

Pull Requests execute the complete validation pipeline without publishing images.

This prevents unreviewed code from being distributed.

Publishing images only from the main branch ensures that only reviewed and validated code becomes available for deployment.

<img width="805" height="384" alt="image" src="https://github.com/user-attachments/assets/a425a909-33e8-4a57-8c96-655e7750ade7" />

<br>

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

<br>

<img width="3082" height="890" alt="image (1)" src="https://github.com/user-attachments/assets/dbbba6b0-2db8-4d82-9a37-815135c36db5" />
