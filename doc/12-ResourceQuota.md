# ResourceQuota

## Overview

In Kubernetes, multiple applications often share the same cluster resources.

Without resource governance, a single application can consume excessive CPU or memory, impacting the stability and performance of other workloads running in the cluster.

`ResourceQuota` is a namespace level Kubernetes resource that limits the total amount of compute resources that can be allocated within a namespace.

In this project, a ResourceQuota was configured for the `bulletin` namespace to control the total CPU and memory resources available to the application.

---

## Why ResourceQuota?

Resource requests and limits protect individual Pods, but they do not prevent an entire namespace from consuming excessive cluster resources.

For example, a user could accidentally deploy multiple workloads with high resource requests, exhausting the available capacity of the cluster.

ResourceQuota solves this problem by defining the maximum amount of resources that all workloads inside a namespace may collectively consume.

This provides:

- Namespace resource isolation
- Fair resource sharing
- Prevention of resource exhaustion
- Better cluster capacity planning

---

## ResourceQuota Architecture

ResourceQuota operates at the namespace level.

Whenever a new Pod is created, Kubernetes calculates the total requested and limited resources for the namespace.

If creating the Pod would exceed the configured quota, the request is rejected before the Pod is scheduled.

```text
                New Pod
                   │
                   ▼
        Resource Requests/Limits
                   │
                   ▼
        Kubernetes ResourceQuota
                   │
          ┌────────┴────────┐
          │                 │
      Within Quota     Exceeds Quota
          │                 │
          ▼                 ▼
     Pod Created      Request Rejected
```

---

## Capacity Planning

Instead of choosing arbitrary quota values, the ResourceQuota was derived from actual application resource consumption.

A dedicated Grafana dashboard was created to monitor:

- Total CPU Usage
- Total Memory Usage
- CPU Requests
- CPU Limits
- Memory Requests
- Memory Limits
- CPU Usage per Pod
- Memory Usage per Pod

The application was then executed under load using a simple HTTP load generator.

The observed metrics were used to define realistic namespace limits.

<img width="1920" height="970" alt="image" src="https://github.com/user-attachments/assets/81e5a7c7-541a-4c84-bf1c-a6c27c3bd835" />

<br>

* netshoot pod was only for testing

During testing, the application consumed approximately:

| Resource | Observed Value |
|----------|---------------:|
| CPU Requests | 0.4 CPU |
| CPU Limits | 2 CPU |
| Memory Requests | 640 MiB |
| Memory Limits | 2 GiB |

Based on these measurements, additional capacity was reserved to allow future scaling while still protecting the cluster.

---

## Implementation

A namespace-scoped ResourceQuota was created with limits for:

- CPU Requests
- CPU Limits
- Memory Requests
- Memory Limits

Configured quota:

| Resource | Quota |
|----------|-------:|
| requests.cpu | 1 CPU |
| limits.cpu | 3 CPU |
| requests.memory | 1 GiB |
| limits.memory | 3 GiB |

<img width="1375" height="208" alt="image" src="https://github.com/user-attachments/assets/8493743f-039d-4f64-8cdd-edec1cb55e6e" />

<br>

---

## Demonstration

To validate the quota, a test Pod was created requesting resources exceeding the configured limits.

The Pod requested:

- 2 CPU Requests
- 4 CPU Limits
- 2 GiB Memory Requests
- 4 GiB Memory Limits

<img width="300" height="409" alt="image" src="https://github.com/user-attachments/assets/396d538f-145a-411e-93ee-5e6ebae2fce2" />

<br>

When the manifest was applied, Kubernetes rejected the request.

<img width="1918" height="63" alt="image" src="https://github.com/user-attachments/assets/b2725c87-aa6d-4969-86b6-51af629444af" />

<br>

This confirms that Kubernetes enforces the namespace quota before scheduling new workloads.

---

## Benefits

The implemented ResourceQuota provides several operational advantages:

- Prevents resource exhaustion
- Protects cluster stability
- Enforces namespace resource isolation
- Supports fair resource sharing
- Improves capacity planning
- Prevents accidental over-allocation
- Encourages predictable resource management

---

## Summary

The implemented ResourceQuota includes:

- Namespace-level resource governance
- CPU Requests quota
- CPU Limits quota
- Memory Requests quota
- Memory Limits quota
- Resource planning based on observed application metrics
- Validation using Grafana monitoring
- Enforcement verified through a failed Pod creation

By implementing ResourceQuota, the `bulletin` namespace is prevented from consuming excessive cluster resources while maintaining sufficient capacity for normal application operation.
