# Role-Based Access Control (RBAC)

## Overview

Kubernetes follows a **deny-by-default** authorization model.

Successfully authenticating to the Kubernetes API does **not** automatically grant permissions. Every authenticated identity must be explicitly authorized through **Role-Based Access Control (RBAC)**.

RBAC is the Kubernetes authorization mechanism used to control **who can perform which actions on which resources**.

It follows the **Principle of Least Privilege**, ensuring that users and applications receive only the permissions required to perform their tasks.

In this project, RBAC was implemented for two different identities:

- A **Developer User** authenticated using a client certificate.
- A **Backend ServiceAccount** used by application Pods.

---

## Why RBAC?

Authentication and authorization are two different security mechanisms.

Authentication answers the question:

> **Who are you?**

Authorization answers the question:

> **What are you allowed to do?**

For example, the developer user can successfully authenticate using a client certificate.

However, before RBAC is configured, Kubernetes denies every request.

```bash
kubectl --kubeconfig developer.kubeconfig get pods
```

Output:

```text
Error from server (Forbidden): User "developer" cannot list resource "pods"
```

The user identity is valid, but no permissions have been granted.

RBAC solves this problem by explicitly defining which operations each identity is allowed to perform.

---

## RBAC Architecture

The implemented RBAC model contains four main components.

### User

A User represents a human interacting with the Kubernetes API.

Unlike many systems, Kubernetes **does not manage users internally**.

Instead, users are authenticated by external identity providers such as:

- Client Certificates
- LDAP
- Active Directory
- OIDC

For this project, the developer user was authenticated using a Kubernetes client certificate.

---

### ServiceAccount

A ServiceAccount represents an application running inside Kubernetes.

Pods use ServiceAccounts whenever they need to authenticate with the Kubernetes API.

Unlike Users, ServiceAccounts are native Kubernetes resources.

---

### Role

A Role defines **which operations are allowed** inside a namespace.

Permissions are defined using:

- Resources
- Verbs

Example:

Resources:

- Pods
- Services
- ConfigMaps

Allowed operations:

- get
- list
- watch

---

### RoleBinding

A RoleBinding connects an identity to a Role.

Without a RoleBinding, permissions are never applied.

Example:

```text
Developer User
        │
        ▼
RoleBinding
        │
        ▼
Developer Role
```

or

```text
Backend ServiceAccount
        │
        ▼
RoleBinding
        │
        ▼
Backend Role
```

---

## Creating the Developer User

Kubernetes does not store users internally.

Instead, a client certificate was generated and signed using the Kubernetes Certificate Signing Request (CSR) API.

The authentication workflow consists of:

1. Generate a private key.
2. Create a Certificate Signing Request (CSR).
3. Submit the CSR to Kubernetes.
4. Approve the request.
5. Receive the signed client certificate.
6. Create a dedicated kubeconfig file.

<img width="1000" height="446" alt="image" src="https://github.com/user-attachments/assets/55b95e9b-fc6e-45a2-b7d5-0a5ee52afc9b" />

<br>

---

## Developer Authorization

After authentication, the developer user still had no permissions.

A namespace-scoped Role was created granting read-only access to:

- Pods
- Services
- ConfigMaps

The Role was associated with the developer user using a RoleBinding.

This allows developers to inspect application resources without modifying them.

<img width="514" height="325" alt="image" src="https://github.com/user-attachments/assets/06914e36-3dc6-4dc5-8938-8cdddf91a0c1" />


<br>

<img width="518" height="307" alt="image" src="https://github.com/user-attachments/assets/f425c502-1d57-4b5f-88e2-0bdabcbcbcac" />

<br>

---

## Backend ServiceAccount

Applications running inside Kubernetes should not use user credentials.

Instead, Kubernetes provides ServiceAccounts for workload authentication.

A dedicated ServiceAccount named:

```text
backend-sa
```

was created and assigned to the backend Deployment.

```yaml
serviceAccountName: backend-sa
```

Whenever backend Pods communicate with the Kubernetes API, they authenticate using this ServiceAccount.

<img width="1349" height="334" alt="image" src="https://github.com/user-attachments/assets/0a1b343c-4841-4a74-a5f4-23561c78636e" />

<br>

---

## Backend Authorization

A dedicated Role was created for the backend ServiceAccount.

The Role grants read-only access to:

- ConfigMaps
- Secrets

A RoleBinding associates the Role with the backend ServiceAccount.

Although the current backend application does not directly communicate with the Kubernetes API, this demonstrates how production workloads should receive only the permissions they require.

<img width="442" height="314" alt="image" src="https://github.com/user-attachments/assets/b416d31b-ab6f-4edc-a625-da24134d180f" />

<br>

<img width="442" height="314" alt="image" src="https://github.com/user-attachments/assets/96d62e25-4f67-42c0-aa7f-5ed901a1893c" />

<br>

---

## Demonstration

### Developer User

The developer user can successfully list application Pods.

<img width="792" height="306" alt="image" src="https://github.com/user-attachments/assets/c2800f88-fd01-422b-9e97-014b6ce81f49" />

<br>

Attempting to access unauthorized resources is denied.

<img width="1458" height="108" alt="image" src="https://github.com/user-attachments/assets/0d75c5f8-a087-4321-8747-203cc83ef1f1" />

<br>

---

### Backend ServiceAccount

The backend permissions were validated using:

```bash
kubectl auth can-i \
get configmaps \
--as=system:serviceaccount:bulletin:backend-sa \
-n bulletin
```

Result:

```text
yes
```

Attempting an unauthorized operation:

```bash
kubectl auth can-i \
delete configmaps \
--as=system:serviceaccount:bulletin:backend-sa \
-n bulletin
```

returns:

```text
no
```

This confirms that the backend ServiceAccount only has the permissions defined by its Role.

<img width="820" height="230" alt="image" src="https://github.com/user-attachments/assets/45c489c5-dfdb-4969-b152-416621c061f7" />


<br>

---

## Benefits

The implemented RBAC configuration provides several security advantages:

- Principle of Least Privilege
- Fine-grained access control
- Namespace isolation
- Secure workload authentication
- Separation between users and applications
- Reduced attack surface
- Prevention of unauthorized operations
- Improved Kubernetes security

---

## Summary

The implemented RBAC configuration includes:

- Developer authentication using client certificates
- Kubernetes Certificate Signing Request (CSR)
- Dedicated developer kubeconfig
- Read-only developer Role
- Developer RoleBinding
- Backend ServiceAccount
- Backend Role
- Backend RoleBinding
- Namespace-scoped authorization
- Permission validation using `kubectl auth can-i`

By implementing RBAC, both users and applications receive only the permissions required for their responsibilities, improving the security and maintainability of the Kubernetes cluster.
