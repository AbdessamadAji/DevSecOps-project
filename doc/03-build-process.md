
# Build Process

## Overview

Before an application can be containerized and deployed, it must first be built into production-ready artifacts.

The frontend and backend follow different build processes because they produce different types of artifacts.

- The frontend is compiled into static assets.
- The backend is packaged as an executable Spring Boot JAR.

These artifacts are later used during the Docker image creation process.

note: I'm not using Multi stage build.
---

# Frontend Build

The frontend is built using Vite.

During development, Vite provides a development server with features such as hot module replacement (HMR) for a faster development experience.

For production, Vite optimizes the application and generates static assets.

## Build Output

Running the production build generates the `dist/` directory.

The directory contains optimized HTML, CSS, JavaScript, and static assets ready to be served by a web server such as Nginx.

<br>

<img width="944" height="312" alt="image" src="https://github.com/user-attachments/assets/8943c793-3ed3-43d2-b193-23b916f80f2a" />

<br>

---

# Backend Build

The backend is built using Gradle.

Gradle compiles the Java source code, executes the project build lifecycle, resolves dependencies, and packages the application.

## Gradle Build Lifecycle

The build process includes:

- Source compilation
- Resource processing
- Testing (if enabled)
- Packaging

## Build Artifact

The final output is an executable Spring Boot BootJar located in:

```text
backend/build/libs/
```

Unlike a standard JAR, a BootJar contains:

- Application classes
- Project dependencies
- Embedded web server
- Runtime configuration

This allows the application to be started using a single command.

<br>

<img width="1105" height="129" alt="image" src="https://github.com/user-attachments/assets/e4234f57-e361-4f2b-a833-b6e5404b688a" />

<br>

---

## Why BootJar?

Spring Boot applications are designed to run as standalone services.

Packaging the application as a BootJar simplifies deployment because all required dependencies are included inside a single executable archive.

This artifact is later copied into the backend Docker image.

---

