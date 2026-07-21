# LimitRange

## Overview

Kubernetes allows developers to define CPU and memory requests and limits for individual Pods and Containers.

However, without additional safeguards, workloads can be created with unrealistic resource values or without resource specifications at all, potentially leading to poor scheduling decisions and resource contention.

`LimitRange` is a Kubernetes policy that defines the minimum and maximum resources allowed for Pods or Containers within a namespace.

In this project, a `LimitRange` was configured for the `bulletin` namespace to ensure that every application container follows predefined CPU and memory constraints.

---

## Why LimitRange?

While `ResourceQuota` controls the **total resources consumed by an entire namespace**, it does not restrict the resource configuration of individual workloads.

For example, a developer could accidentally deploy a container requesting:

```yaml
resources:
  limits:
    cpu: "4"
    memory: "8Gi"
```

or create a workload with extremely small resource requests.

`LimitRange` prevents these situations by enforcing namespace-wide policies for every container.

This provides:

- Consistent resource allocation
- Protection against misconfigured workloads
- Better scheduling decisions
- Standardized resource policies across applications

---

## LimitRange Architecture

LimitRange operates at the namespace level.

Whenever a new Pod is created, Kubernetes validates the resource requests and limits of every container against the configured policy.

If the container satisfies the configured constraints, Kubernetes accepts the Pod.

Otherwise, the Pod creation request is rejected before scheduling.

```text
                 New Pod
                    │
                    ▼
         Container Resources
                    │
                    ▼
         Kubernetes LimitRange
                    │
          ┌─────────┴─────────┐
          │                   │
      Within Limits     Outside Limits
          │                   │
          ▼                   ▼
     Pod Created       Request Rejected
```

---

## Resource Policy

The resource policy for this project was derived from the standard resource configuration used by the application components.

Every application container (Frontend, Backend, PostgreSQL and MinIO) follows the same resource profile, allowing a consistent namespace-wide policy to be enforced.

The configured LimitRange defines:

| Resource | Minimum | Maximum |
|----------|---------:|---------:|
| CPU | 100m | 500m |
| Memory | 128Mi | 512Mi |


<img width="1207" height="174" alt="image" src="https://github.com/user-attachments/assets/f86c9fcf-0b31-4e30-969e-2c0257e87557" />

<br>

---

## Implementation

A namespace-scoped LimitRange was created for the `bulletin` namespace.

The policy enforces:

- Minimum CPU request of **100m**
- Maximum CPU limit of **500m**
- Minimum memory request of **128Mi**
- Maximum memory limit of **512Mi**

Any container created inside the namespace must satisfy these constraints.

<img width="488" height="367" alt="image" src="https://github.com/user-attachments/assets/d5312819-6c2b-4cd3-80f8-a753a27c0a8e" />

<br>

---

## Demonstration

### Pod exceeding the configured limits

A test Pod was created requesting resources greater than the allowed maximum.

<img width="488" height="415" alt="image" src="https://github.com/user-attachments/assets/a8a3bde9-1137-41ff-80a8-c07f4be94a92" />

<br>

Kubernetes rejected the Pod before scheduling it.

<img width="1920" height="67" alt="image" src="https://github.com/user-attachments/assets/c3b305d6-3dc5-4e6d-bb7c-dbab198cfe62" />


<br>

---

### Pod within the configured limits

A second test Pod was created using values that satisfy the configured policy.

<img width="374" height="407" alt="image" src="https://github.com/user-attachments/assets/456aad07-0f4b-4bf4-8882-839a816505f2" />

<br>

The Pod was successfully created, confirming that Kubernetes accepts workloads that comply with the LimitRange policy.

<img width="1035" height="44" alt="image" src="https://github.com/user-attachments/assets/b76816e7-7cb3-4561-be08-fcbcdbf8ee77" />

<br>

---

## Benefits

The implemented LimitRange provides several operational advantages:

- Enforces consistent resource policies
- Prevents oversized container resource allocations
- Prevents unrealistic resource configurations
- Improves Kubernetes scheduling decisions
- Standardizes resource allocation across workloads
- Reduces the risk of resource misconfiguration
- Complements namespace-level ResourceQuota enforcement

---

## Summary

The implemented LimitRange includes:

- Namespace-scoped resource policy
- Minimum CPU and memory constraints
- Maximum CPU and memory constraints
- Validation of container resource requests and limits
- Successful deployment of a compliant Pod
- Rejection of workloads exceeding the configured limits

By implementing LimitRange, every container deployed in the `bulletin` namespace follows a consistent resource policy, improving workload reliability and complementing the namespace-wide protection provided by ResourceQuota.
