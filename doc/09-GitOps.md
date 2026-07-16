# GitOps with ArgoCD

## Overview

Deploying an application to Kubernetes using `kubectl apply` works well for small environments. However, as infrastructure grows, manually applying manifests becomes increasingly difficult to manage.

Every deployment depends on engineers executing the correct commands, targeting the correct cluster, and applying the latest version of the manifests. This manual process introduces several operational challenges:

- Configuration drift between Git and the cluster
- Human errors during deployments
- No automatic synchronization
- Limited deployment traceability
- Difficult rollback procedures
- Inconsistent cluster state

GitOps addresses these problems by making Git the single source of truth for the entire Kubernetes environment.

Instead of engineers manually applying manifests, a GitOps controller continuously compares the desired state stored in Git with the actual state running inside Kubernetes.

Whenever a difference is detected, the controller reconciles the cluster until both states become identical.

In this project, GitOps was implemented using **ArgoCD**, which continuously monitors the Git repository and automatically synchronizes Kubernetes resources with the desired configuration.

---

## Why GitOps?

Traditional Kubernetes deployments usually follow this workflow:

```text
Engineer
     │
     ▼
kubectl apply
     │
     ▼
Kubernetes Cluster
```

Although simple, this approach has several limitations.

If someone modifies a Deployment directly inside the cluster using:

```bash
kubectl scale deployment frontend-deploy --replicas=8
```

the cluster configuration changes immediately, but Git remains unchanged.

After some time, nobody can confidently answer questions such as:

- Which configuration is correct?
- Who changed it?
- When was it modified?
- Should the cluster be reverted?

This inconsistency is known as **Configuration Drift**.

GitOps eliminates this issue by reversing the deployment model.

Instead of pushing changes from engineers to Kubernetes, Kubernetes continuously pulls the desired configuration from Git.

The deployment workflow becomes:

```text
Engineer
     │
     ▼
Git Repository
     │
     ▼
ArgoCD
     │
     ▼
Kubernetes Cluster
```

Git becomes the authoritative source of truth, while ArgoCD ensures the cluster always matches the repository.

---

## GitOps Architecture

The implemented GitOps workflow consists of four main components:

- GitHub Repository
- ArgoCD
- Kubernetes Cluster
- Application Resources

The workflow is straightforward:

1. A configuration change is committed to Git.
2. ArgoCD continuously monitors the repository.
3. The repository state is compared with the live cluster.
4. Differences are detected.
5. Kubernetes is synchronized to match Git.

<img width="1536" height="1024" alt="image" src="https://github.com/user-attachments/assets/deb2533a-1838-4593-adfb-91b607164a26" />


<br>

---

## Installing ArgoCD

ArgoCD was installed inside a dedicated Kubernetes namespace named `argocd` using the official Helm chart.

The deployment includes the following components:

- API Server
- Application Controller
- Repository Server
- Redis
- ApplicationSet Controller

Deploying ArgoCD with Helm simplifies upgrades, maintenance, and configuration management.

<img width="884" height="180" alt="image" src="https://github.com/user-attachments/assets/31e2315c-7642-42ee-8313-e15c59d4f64b" />


<br>

---

## Creating an AppProject

Before deploying applications, an **AppProject** was created.

The AppProject defines the boundaries that applications are allowed to use.

For this project it specifies:

- Authorized Git repository
- Allowed Kubernetes cluster
- Allowed namespace
- Allowed Kubernetes resources

Using AppProjects improves security by preventing applications from deploying resources outside their intended scope.

<img width="667" height="476" alt="image" src="https://github.com/user-attachments/assets/982bbcfa-53b2-4cc5-abb5-f136f8436a36" />


<br>

---

## Creating the Application

After creating the AppProject, an ArgoCD Application was configured.

The application defines:

- Repository URL
- Git branch
- Manifest path
- Destination cluster
- Namespace

Once created, ArgoCD continuously compares the Kubernetes cluster with the manifests stored inside Git.

<img width="1920" height="878" alt="image" src="https://github.com/user-attachments/assets/9d25770f-438a-4b3e-8351-533d5a76ee41" />


<br>

---

## Manual Synchronization

Initially, synchronization was configured in **Manual Sync** mode.

When a manifest changes inside Git:

- ArgoCD detects the new commit.
- The application becomes **OutOfSync**.
- Nothing is deployed until the user presses **Sync**.

This mode gives operators full deployment control.

### Demonstration

The frontend Deployment replicas were changed from **2** to **3** inside Git.

After pushing the commit:

- ArgoCD detected the new revision.
- The application became **OutOfSync**.
- Pressing **Sync** updated Kubernetes to match Git.

<img width="1920" height="373" alt="image" src="https://github.com/user-attachments/assets/5a927dac-1ac6-478f-b245-90e769c16158" />


<br>

---

## Automatic Synchronization

After validating manual deployments, **Auto Sync** was enabled.

With Auto Sync enabled:

- Every Git commit is detected automatically.
- Synchronization starts without user intervention.
- Kubernetes always follows Git.

The deployment workflow becomes:

```text
Edit Manifest
      │
      ▼
Git Commit
      │
      ▼
Git Push
      │
      ▼
ArgoCD detects commit
      │
      ▼
Automatic Sync
      │
      ▼
Cluster Updated
```

### Demonstration

The frontend replicas were modified from **2** to **4**.

After pushing the commit:

- No Sync button was pressed.
- ArgoCD detected the new revision.
- Kubernetes automatically scaled the Deployment.

<img width="1503" height="332" alt="image" src="https://github.com/user-attachments/assets/223dcba3-7463-4d37-a26a-f44e7e5fbbf6" />

<br>

---

## Detecting Configuration Drift

One major GitOps feature is **Configuration Drift Detection**.

ArgoCD continuously compares:

- Desired State (Git)
- Live State (Kubernetes)

If someone changes Kubernetes manually, ArgoCD immediately detects the difference.

Example:

```bash
kubectl scale deployment frontend-deploy \
--replicas=8 \
-n bulletin
```

Git still contains:

```yaml
replicas: 2
```

ArgoCD immediately marks the application as **OutOfSync**.

The Diff view clearly highlights the modified resource.

<img width="1920" height="443" alt="image" src="https://github.com/user-attachments/assets/c4874289-cbe3-472f-847b-5aae83746042" />

<br>

---

## Self-Healing

Detecting drift is useful, but automatically correcting it is even more valuable.

For this reason, **Self-Healing** was enabled.

Whenever someone changes the cluster directly, ArgoCD automatically restores the desired configuration stored in Git.

### Demonstration

Git:

```yaml
replicas: 2
```

Manual modification:

```bash
kubectl scale deployment frontend-deploy \
--replicas=8
```

Within a few seconds:

- ArgoCD detected the drift.
- ArgoCD synchronized automatically.
- Kubernetes returned to **2 replicas**.

No human intervention was required.

<img width="1920" height="1008" alt="Screenshot from 2026-07-16 18-45-05" src="https://github.com/user-attachments/assets/9c3a9941-4ca9-4719-8926-05f9138c0391" />


<br>

---

## Deployment History

Every synchronization performed by ArgoCD is recorded.

Each deployment stores:

- Git Revision
- Commit Author
- Deployment Time
- Commit Message

This provides complete deployment traceability.

<img width="1920" height="966" alt="image" src="https://github.com/user-attachments/assets/b8dfce0f-699f-48e9-86c4-3de049f5f693" />


<br>

---

## Rollback

If a deployment introduces an issue, ArgoCD can restore a previous revision.

Rollback significantly reduces recovery time because previous deployments are already stored.

When Auto Sync is enabled, ArgoCD requires temporarily disabling it before performing a rollback to avoid immediately reapplying the latest Git revision.

<img width="1920" height="1008" alt="Screenshot from 2026-07-16 20-07-48" src="https://github.com/user-attachments/assets/3cd694fa-1dac-41a0-8b7b-c9bdfefe026a" />


<br>

---

## Benefits

The implemented GitOps workflow provides several operational advantages:

- Git becomes the single source of truth
- Declarative deployments
- Automatic synchronization
- Configuration drift detection
- Automatic self-healing
- Deployment history
- Simplified rollback
- Reduced manual operations
- Better auditability
- Consistent Kubernetes deployments

---

## Summary

The GitOps implementation includes:

- ArgoCD deployed using Helm
- Dedicated AppProject
- GitHub repository integration
- Kubernetes Application management
- Manual synchronization
- Automatic synchronization
- Configuration drift detection
- Diff visualization
- Self-Healing
- Deployment history
- Rollback support

By adopting GitOps, Kubernetes deployments become declarative, reproducible, continuously reconciled with Git, and significantly more reliable than traditional manual deployment workflows.
