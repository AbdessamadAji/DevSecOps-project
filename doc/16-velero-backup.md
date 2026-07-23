# Kubernetes Backup with Velero

## Overview

Backing up a Kubernetes cluster requires more than simply saving application code.
Cluster resources such as Deployments, Services, ConfigMaps, Secrets, PVC definitions, RBAC, and NetworkPolicies should also be protected.

For this project, Velero was implemented to back up Kubernetes resources and store them in a MinIO bucket.

---

## Why Velero?

Velero is an open-source Kubernetes backup and disaster recovery solution.

It provides:

- Backup of Kubernetes resources
- Restore of Kubernetes resources
- Scheduled backups
- Backup storage integration (AWS S3, MinIO, Azure, GCP...)

In this project, MinIO was used as an S3-compatible backup storage.

---

## Architecture

```
Kubernetes Cluster
        │
        │ Backup
        ▼
    Velero
        │
        │ S3 API
        ▼
      MinIO
```

---

## Implementation

Velero was installed with:

- AWS Plugin
- MinIO as BackupStorageLocation
- Kopia uploader
- Node Agent
- Filesystem Backup enabled

The backup storage location was successfully configured and reached the **Available** state.

<img width="1073" height="97" alt="image" src="https://github.com/user-attachments/assets/5b9efe64-c263-4c86-9e30-3bf6222967e6" />

---

## HostPath Limitation

Initially, the objective was to back up Persistent Volume contents using Velero.

However, the project runs on **Minikube**, where the default StorageClass uses HostPath volumes.

Velero detected the volumes but skipped filesystem backups because HostPath volumes are not supported for PodVolumeBackup.

As a result:

- Kubernetes resources are backed up successfully.
- Persistent data is not backed up by Velero.

This limitation led to a different backup strategy for application data.


---

## Final Backup Strategy

Instead of relying entirely on Velero, the backup strategy was divided into two parts:

| Component | Backup Method |
|-----------|---------------|
| Kubernetes Resources | Velero |
| PostgreSQL Database | pg_dump |
| MinIO Objects | Stored directly in MinIO |

This separation follows a common production approach where infrastructure and application data are backed up independently.

---

## Benefits

- Kubernetes-native backup solution
- Supports scheduled backups
- Compatible with S3 storage
- Easy restore of Kubernetes resources
- Production-oriented architecture

---

## Summary

Velero successfully protects the Kubernetes cluster configuration.

Because Minikube HostPath volumes cannot be backed up using PodVolumeBackup, PostgreSQL data is backed up separately using `pg_dump`.
