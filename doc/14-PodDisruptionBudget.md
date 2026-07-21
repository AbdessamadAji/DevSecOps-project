# PodDisruptionBudget (PDB)

## Overview

High availability is an important aspect of production Kubernetes environments.

During planned maintenance operations such as node upgrades or node draining, Kubernetes may need to evict running Pods.

Without protection, multiple replicas of the same application could be disrupted simultaneously, resulting in temporary service unavailability.

`PodDisruptionBudget (PDB)` is a Kubernetes policy that limits the number of application replicas that may be voluntarily disrupted at the same time.

In this project, PodDisruptionBudgets were configured for both the frontend and backend applications to ensure that at least one replica always remains available during planned maintenance.

---

## Why PodDisruptionBudget?

Deployments maintain the desired number of replicas, but they do not prevent Kubernetes from voluntarily evicting multiple Pods during maintenance operations.

Examples of voluntary disruptions include:

- Node draining
- Kubernetes cluster upgrades
- Node maintenance
- Cluster Autoscaler scale-down

Without a PDB, Kubernetes could temporarily evict multiple replicas of the same application, increasing the risk of service interruption.

PodDisruptionBudget reduces this risk by enforcing minimum application availability during these operations.

---

## PodDisruptionBudget Architecture

When Kubernetes receives a voluntary eviction request, it first evaluates the configured PodDisruptionBudget.

If the eviction would violate the availability requirement, Kubernetes rejects the request.

```text
            Eviction Request
                    │
                    ▼
        Kubernetes PodDisruptionBudget
                    │
         ┌──────────┴──────────┐
         │                     │
 Availability Maintained   Availability Violated
         │                     │
         ▼                     ▼
   Eviction Allowed     Eviction Rejected
```

---

## Implementation

Two PodDisruptionBudgets were created inside the `bulletin` namespace.

### Backend

The backend Deployment runs two replicas.

The following policy was configured:

- Minimum available replicas: **1**

This allows Kubernetes to evict only one backend Pod at a time while ensuring that another replica continues serving requests.

---

### Frontend

The frontend Deployment also runs two replicas.

The same policy was applied:

- Minimum available replicas: **1**

This ensures that the frontend remains available during voluntary maintenance operations.

---

## Configuration

The configured PodDisruptionBudgets can be verified using:

<img width="918" height="112" alt="image" src="https://github.com/user-attachments/assets/4b176664-e363-4a68-b146-c6ce622f89fc" />

<br>

The `ALLOWED DISRUPTIONS` column indicates how many Pods Kubernetes may voluntarily evict without violating the configured availability policy.

The configured PodDisruptionBudgets were successfully created and validated within the cluster.

Kubernetes reports that each application allows only one voluntary disruption while maintaining the required minimum number of available replicas.

This confirms that the availability policy is active and will be enforced during supported maintenance operations such as node draining or controlled Pod evictions.

---

## Benefits

The implemented PodDisruptionBudgets provide several operational advantages:

- Improves application availability during planned maintenance
- Prevents simultaneous eviction of all application replicas
- Supports rolling maintenance operations
- Reduces the risk of service downtime
- Protects critical workloads during voluntary disruptions
- Complements Kubernetes Deployment high availability

---

## Summary

The implemented PodDisruptionBudget configuration includes:

- Namespace-scoped availability policies
- Backend PodDisruptionBudget
- Frontend PodDisruptionBudget
- Minimum available replicas set to one
- Validation using `kubectl get pdb`

By implementing PodDisruptionBudgets, the frontend and backend applications maintain at least one available replica during voluntary disruptions, improving service availability and operational resilience.
