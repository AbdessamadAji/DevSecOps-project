# Kubernetes Network Policies

## Overview

By default, Kubernetes does not restrict communication between Pods running inside the same cluster.

Unless additional controls are implemented, every Pod can communicate with every other Pod, regardless of the application it belongs to.

For production environments, unrestricted Pod-to-Pod communication increases the attack surface and allows lateral movement if a workload is compromised.

Network Policies provide a Kubernetes-native mechanism for controlling network traffic between Pods.

In this project, Network Policies were implemented to enforce communication only between the application components that require it.

---

## Why Network Policies?

Container isolation alone does not prevent network communication.

Without Network Policies, a compromised Pod can freely connect to any reachable service inside the cluster.

For example:

- Frontend Pods could connect directly to PostgreSQL.
- Any application could attempt to access MinIO.
- Unnecessary communication paths remain available.

Following the Principle of Least Privilege, workloads should only communicate with the services required for their functionality.

Network Policies enforce this principle by explicitly allowing only authorized traffic.

---

## Network Policy Model

The implemented network security model follows a default-deny approach.

```text
Default Deny
       │
       ▼
Allow only required communication
```

Instead of allowing every connection by default, all traffic is denied unless explicitly permitted.

The implemented communication paths are:

- Frontend → Backend
- Backend → PostgreSQL
- Backend → MinIO
- Prometheus → Backend Metrics

Every other communication path remains blocked.

<img width="977" height="148" alt="image" src="https://github.com/user-attachments/assets/1fa3b4e2-0714-4fd2-a3db-5daed9d45410" />
<br>


---

## Default Deny Policy

The first implemented policy denies all ingress and egress traffic inside the `bulletin` namespace.

This policy establishes a secure baseline.

After applying the policy, Pods cannot communicate until additional allow policies are created.

<img width="463" height="246" alt="image" src="https://github.com/user-attachments/assets/9a2887ac-219a-4c69-9985-d042f6d3f29d" />

<br>

---

## Allowing Required Communication

After establishing the default deny policy, individual allow policies were created for each required communication path.

The implemented policies include:

- Frontend → Backend
- Backend → PostgreSQL
- Backend → MinIO
- Prometheus → Backend Metrics

Each policy grants access only to the required destination Pod and port.

This minimizes unnecessary network exposure while preserving application functionality.

<img width="1536" height="1024" alt="image" src="https://github.com/user-attachments/assets/36b4c640-1db8-464a-8cff-f84903b6ee80" />

<br>

---

## Demonstration

Network connectivity was validated using temporary debugging Pods.

Successful communication was verified only for explicitly authorized connections.

<img width="1138" height="128" alt="image" src="https://github.com/user-attachments/assets/5c8d27d4-fe98-4997-afc4-5e2773248a33" />

<br>

Unauthorized communication attempts were expected to fail.

Because the current Minikube installation does not use a CNI plugin supporting NetworkPolicy enforcement, the policies are accepted by Kubernetes but are not enforced at runtime.

This behavior is expected and represents a limitation of the local development environment rather than the NetworkPolicy configuration itself.

<img width="913" height="168" alt="image" src="https://github.com/user-attachments/assets/182e3e82-2962-451c-b118-4dfddb643e4c" />

<br>

---

## Environment Limitation

NetworkPolicy enforcement depends on the Kubernetes CNI plugin.

The local Minikube cluster used for this project does not include a NetworkPolicy-capable CNI such as:

- Calico
- Cilium
- Antrea

As a result:

- Kubernetes successfully stores the NetworkPolicy resources.
- Communication rules are not enforced by the networking layer.

In production environments using a compatible CNI plugin, the same policies would be fully enforced without modification.

---

## Benefits

The implemented Network Policies provide several security advantages:

- Default-deny networking
- Reduced attack surface
- Controlled Pod-to-Pod communication
- Application isolation
- Prevention of unnecessary lateral movement
- Namespace-level network segmentation
- Principle of Least Privilege

---

## Summary

The implemented network security configuration includes:

- Namespace-wide default deny policy
- Explicit allow policies
- Frontend to Backend communication
- Backend to PostgreSQL communication
- Backend to MinIO communication
- Prometheus metrics access
- Network connectivity validation
- Documentation of local CNI limitations

By implementing Network Policies, application communication becomes explicit, predictable, and significantly more secure than the default unrestricted Kubernetes networking model.
