# Scalable Backend Deployment on AWS using Kubernetes + Terraform

This project demonstrates a **cloud-native scalable backend system deployed on AWS (EKS)** using Terraform and Kubernetes.  
It follows production-grade practices including **High Availability, Auto Scaling, Ingress exposure, and Stateful database design**.

---

# Project Goal

Build and deploy a **scalable CRUD backend service (Posts API)** on AWS with:

- Kubernetes (EKS)
- Auto Scaling (HPA)
- MongoDB ReplicaSet (StatefulSet)
- Ingress via AWS Load Balancer Controller
- Infrastructure as Code using Terraform

---

# Cloud Environment (AWS)

This project is deployed and tested on:

- AWS EKS (Managed Kubernetes Cluster)
- AWS VPC (Custom networking with public/private subnets)
- AWS ALB (Application Load Balancer via Ingress Controller)
- IAM Roles for Service Accounts (IRSA)

✔ All infrastructure is provisioned using Terraform on AWS

---

# Architecture Overview (End-to-End System Design)

The system follows a layered cloud-native architecture on AWS EKS:

---

## High-Level Flow

```
User
  ↓
AWS Application Load Balancer (ALB)
  ↓
Kubernetes Ingress (AWS Load Balancer Controller)
  ↓
Kubernetes Service (ClusterIP)
  ↓
Backend Pods (Deployment + HPA Auto Scaling)
  ↓
MongoDB ReplicaSet (StatefulSet)
  ↓
Persistent Storage (AWS EBS via CSI Driver)
```

---

## Infrastructure Layer (Terraform)

The system follows a layered cloud-native architecture on AWS EKS:


- VPC (Multi-AZ, Public & Private Subnets)
- Internet Gateway + NAT Gateway
- EKS Managed Kubernetes Cluster
- IAM Roles (IRSA for secure service access)
- EKS Managed Node Groups
- AWS EKS Add-ons:
  - EBS CSI Driver (Persistent Storage)

---

## Kubernetes Add-ons Layer (Helm)

- AWS Load Balancer Controller
  → Automatically provisions ALB for Ingress

- Metrics Server
  → Enables Horizontal Pod Autoscaling (HPA)

---

## Application Layer (Kubernetes Manifests)

- Backend API (Node.js CRUD service)
  - Deployment
  - Service (ClusterIP)
  - HPA (min: 1, max: 5, CPU 70%)

- MongoDB Database
  - StatefulSet (3 replicas)
  - ReplicaSet enabled
  - Persistent Volume (EBS-backed storage)

---

## Key Design Principles

- Separation of concerns (Infra / Cluster / App)
- High Availability (Multi-AZ + ReplicaSet)
- Auto Scaling (HPA for backend pods)
- Fault Tolerance (pod + node failure recovery)
- Persistent Storage (EBS-backed MongoDB data)
- Cloud-native AWS integration

---

# Architecture (Simplified Flow)

The system follows a layered cloud-native architecture on AWS EKS:


```
User → ALB → Ingress → Service → Backend Pods → MongoDB ReplicaSet → EBS Storage
```

---

# Repository Structure

```
.
├── backend/              # Node.js CRUD API
├── k8s/                  # Kubernetes manifests
│   ├── backend/
│   ├── mongo/
│   ├── ingress/
│   └── namespace.yaml
│
├── terraform/           # AWS Infrastructure (VPC + EKS)
│   ├── modules/
│   ├── helm/
│   ├── main.tf
│   ├── outputs.tf
```

---

# Deployment Workflow (AWS)

## 1. Provision AWS Infrastructure (Terraform)

```bash
cd terraform
terraform init
terraform apply
```

✔ Creates:
- VPC (public/private subnets)
- Internet Gateway
- NAT Gateway
- EKS Cluster (backend-eks)
- Node Groups (Auto Scaling enabled)
- IAM Roles for EKS

---

## 2. Configure kubectl for AWS EKS

```bash
aws eks update-kubeconfig \
  --region us-east-1 \
  --name backend-eks
```

✔ Connects local CLI to AWS EKS cluster

---

## 3. Deploy Kubernetes Resources

```bash
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/mongo/
kubectl apply -f k8s/backend/
kubectl apply -f k8s/ingress/
```

✔ Deploys full application stack on AWS EKS

---

## 4. Access Application via AWS Ingress

After deployment, AWS automatically provisions an **Application Load Balancer (ALB)**:

```
http://<ALB-DNS>/posts
```

✔ External API access via AWS Load Balancer

---

# Backend API

Simple CRUD API for Posts:

```
GET    /posts
POST   /posts
GET    /posts/:id
PUT    /posts/:id
DELETE /posts/:id
```

---

# Auto Scaling (HPA)

- Min Pods: 1  
- Max Pods: 5  
- CPU Threshold: 70%

✔ Kubernetes automatically scales backend pods under load

---

# Database (MongoDB ReplicaSet)

- 3 MongoDB pods using StatefulSet
- Persistent Volumes attached
- ReplicaSet ensures data redundancy

✔ High Availability  
✔ No data loss on pod restart  

---

# MongoDB ReplicaSet Initialization (Important Step)

After StatefulSet pods are running, initialize the ReplicaSet:

```bash
kubectl exec -it mongo-0 -n k8s-backend -- mongo
```

Then run:

```javascript
rs.initiate({
  _id: "rs0",
  members: [
    { _id: 0, host: "mongo-0.mongo:27017" },
    { _id: 1, host: "mongo-1.mongo:27017" },
    { _id: 2, host: "mongo-2.mongo:27017" }
  ]
})
```

✔ Enables:

- Primary / Secondary election
- Data replication
- High Availability mode

---

# Replica Set Verification

```
rs.status()
```

✔ Expected:

- 1 PRIMARY
- 2 SECONDARY 
- All HEALTH = 1

---

# Ingress (AWS ALB)

- AWS Load Balancer Controller installed via Helm
- Automatically provisions ALB
- Routes external traffic to backend service

✔ Fully managed AWS load balancing  
✔ Production-ready ingress layer  

---

# AWS-Based Validation Tests

## API Accessibility via AWS ALB

```
http://<alb-dns>/posts
```

---

## Auto Scaling Test

```bash
seq 1 20000 | xargs -n1 -P20 curl -s http://<ALB-DNS>/posts > /dev/null
kubectl get hpa -n k8s-backend -w
kubectl get pods -n k8s-backend -w
```

Generate load → pods scale from 1 → up to 5

---

## High Availability Test

```bash
kubectl delete pod <backend-pod>
```

✔ System continues working without downtime

---

## MongoDB Fault Tolerance

```bash
kubectl delete pod <mongo-pod>
```

✔ ReplicaSet restores pod automatically  
✔ Data remains intact

---

# Terraform Outputs (Used in Deployment)

- VPC ID
- Private Subnets
- EKS Cluster Name
- Cluster Endpoint

✔ Used automatically for Kubernetes + Helm integration

---

# Key Highlights

- Fully deployed on AWS EKS
- Infrastructure as Code using Terraform
- Production-like Kubernetes architecture
- Horizontal Auto Scaling (HPA)
- Stateful MongoDB ReplicaSet
- AWS ALB Ingress Controller integration
- High Availability + Fault tolerance design

---

# Storage Layer

- Persistent storage is implemented using AWS EBS (Elastic Block Store)
- Kubernetes StorageClass is used for dynamic provisioning
- MongoDB StatefulSet is backed by persistent volumes to ensure data durability

---

# Key Highlights

- Fully deployed on AWS EKS
- Infrastructure as Code using Terraform
- Production-like Kubernetes architecture
- Horizontal Auto Scaling (HPA)
- Stateful MongoDB ReplicaSet
- AWS ALB Ingress Controller integration
- High Availability + Fault tolerance design

---

# Required Demo (Submission)

- AWS infrastructure (Terraform)
- Kubernetes deployment on EKS
- Live API access ALB
- Auto scaling in action
- Pod failure recovery
- MongoDB resilience test

---

# Notes

- AWS credentials required
- EKS cluster must be created before Kubernetes deployment
- ALB is automatically provisioned via AWS Load Balancer Controller
