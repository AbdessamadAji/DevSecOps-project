# PostgreSQL Backup

## Overview

Backing up Kubernetes resources alone is not sufficient because the application data stored inside PostgreSQL would still be lost.

To protect the database, an automated backup solution was implemented using `pg_dump`.

The generated SQL dump is uploaded to MinIO, providing centralized and persistent backup storage.

<img width="892" height="127" alt="image" src="https://github.com/user-attachments/assets/1bc234c4-b602-4d34-b7f0-6cf36e9706cb" />

<br>

---

## Why pg_dump?

`pg_dump` is the official PostgreSQL backup utility.

Advantages:

- Reliable
- Portable
- Easy to restore
- Widely used in production

Unlike filesystem backups, SQL dumps are independent of Kubernetes storage.

---

## Architecture

```
PostgreSQL
      │
      │ pg_dump
      ▼
 SQL Dump
      │
      │ mc cp
      ▼
 MinIO
```

---

## Backup Workflow

The backup process follows these steps:

1. Connect to PostgreSQL
2. Generate an SQL dump using `pg_dump`
3. Store the dump temporarily inside the container
4. Connect to MinIO using the MinIO Client (`mc`)
5. Upload the SQL file to the `postgres-backups` bucket
6. Remove the temporary file

---

## Automation

The backup process runs inside a Kubernetes CronJob.

The CronJob:

- Loads PostgreSQL credentials from Kubernetes Secrets
- Loads MinIO credentials from Kubernetes Secrets
- Executes the backup script automatically

<img width="1532" height="264" alt="image" src="https://github.com/user-attachments/assets/4b47e4e2-8150-414a-b4cd-bc4b76766be9" />

<br>

---

## Security

Sensitive information is never hardcoded.

Credentials are injected through:

- postgres-secret
- minio-secret

The container also follows basic hardening practices:

- Non-root user
- Resource requests and limits
- No privileged execution

<img width="704" height="328" alt="image" src="https://github.com/user-attachments/assets/7e1203f1-2f21-44a7-ab7c-0f1d2de8b029" />

<br>

---

## Verification

The backup process was validated by checking:

- Successful Job completion
- Backup logs
- SQL file uploaded to MinIO

The generated SQL dump was successfully stored inside the `postgres-backups` bucket.

<img width="1220" height="388" alt="image" src="https://github.com/user-attachments/assets/6493c052-2eb8-4a03-993f-e3e6825f1662" />

<br>

<img width="845" height="69" alt="image" src="https://github.com/user-attachments/assets/8a75d03f-8fa6-44bb-bea0-3e0d8b0da3ad" />

<br>

---

## Benefits

- Automated database backup
- Secure credential management
- Production-oriented workflow
- S3-compatible storage
- Easy integration with Kubernetes CronJobs

---

## Summary

A complete PostgreSQL backup workflow was implemented using `pg_dump`, Kubernetes CronJobs, and MinIO.

This solution complements Velero by protecting the application data while Velero protects the Kubernetes resources.
