
# Application Architecture

## Overview

The application follows a classic three-tier architecture composed of a frontend, a backend, and a database.

The frontend provides the user interface, the backend exposes a REST API that implements the business logic, and PostgreSQL stores the application data.

---

## High-Level Architecture

<br>

<img width="1122" height="1402" alt="image" src="https://github.com/user-attachments/assets/431533ef-0c69-4cb5-b78a-cf962d6dabe6" />

<br>

---

## Components

### Frontend

The frontend is built with React, React Admin, TypeScript, and Vite.

It provides an administrative interface that communicates with the backend through REST APIs.

In production, the frontend is served as static files by Nginx.

---

### Backend

The backend is developed with Spring Boot and follows a layered architecture.

It exposes REST endpoints, processes business logic, interacts with the database, and manages file storage.

The application also provides Swagger documentation and Spring Boot Actuator endpoints for observability.

---

### Database

PostgreSQL is used as the primary database for the production environment.

The backend communicates directly with the database using Spring Data JPA.

---

## Request Flow

A typical request follows these steps:

1. The user interacts with the React application.
2. The frontend sends an HTTP request to the Spring Boot REST API.
3. The backend validates and processes the request.
4. Business logic interacts with PostgreSQL when necessary.
5. The backend returns a JSON response.
6. The frontend updates the user interface.

<br>

<img width="1536" height="1024" alt="image" src="https://github.com/user-attachments/assets/9941013f-bce2-4e3a-92dc-233de6421721" />

---

## Project Structure

The repository is organized into two main applications:

```text
frontend/
backend/
```

- `frontend/` contains the React application.
- `backend/` contains the Spring Boot application.

---

## Backend Architecture

The backend follows Spring Boot's layered architecture.

```text
Controller
    │
    ▼
Service
    │
    ▼
Repository
    │
    ▼
PostgreSQL
```

Each layer has a single responsibility:

- Controllers expose REST endpoints.
- Services contain business logic.
- Repositories handle database operations.

---

## Frontend Architecture

<br>

<img width="1920" height="1005" alt="Screenshot from 2026-07-02 01-38-41" src="https://github.com/user-attachments/assets/3d7ad154-dddd-4548-bab2-d74e1815c9eb" />

<br>

The frontend is organized into reusable React components, pages, layouts, and API providers.

React Admin is responsible for the administrative interface, while Vite is used for development and production builds.

<br>

<img width="1203" height="1308" alt="image" src="https://github.com/user-attachments/assets/3ad61238-4478-40fd-988d-4dd3b6081848" />
