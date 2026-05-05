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
- Containerized backend using Docker

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

# Cloud Environment (AWS)

This project is designed for AWS production-like environment:

- AWS EKS (Managed Kubernetes Cluster)
- AWS VPC (Custom networking with public/private subnets)
- AWS ALB (Application Load Balancer via Ingress Controller)
- IAM Roles for Service Accounts (IRSA)

✔ Infrastructure is fully provisioned using Terraform

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

# Infrastructure Layer (Terraform)

The system follows a layered cloud-native architecture on AWS EKS:


- VPC (Multi-AZ, Public & Private Subnets)
- Internet Gateway + NAT Gateway
- EKS Managed Kubernetes Cluster
- IAM Roles (IRSA for secure service access)
- EKS Managed Node Groups
- AWS EKS Add-ons:
  - EBS CSI Driver (Persistent Storage)
  - Metrics Server (HPA support)
  - AWS Load Balancer Controller (Ingress)


## Kubernetes Add-ons Layer (Helm)

- AWS Load Balancer Controller
  → Automatically provisions ALB for Ingress

- Metrics Server
  → Enables Horizontal Pod Autoscaling (HPA)

---

# Application Layer 

## Backend API (Node.js)

- REST CRUD API for Posts
- Deployed as Kubernetes Deployment
- Exposed via ClusterIP Service
- Scales using HPA (1 → 5 pods)


---

## Containerization (Docker Layer)


The backend is containerized before Kubernetes deployment.

### Why Docker?
- Ensures consistent runtime across environments
- Enables Kubernetes deployments
- Improves portability and scaling

### Flow

```
Backend Code → Dockerfile → Docker Image → Docker Hub / ECR → Kubernetes Deployment
```

### Docker Hub Image

```
abodiaa/backend-api:latest
```

✔ Used directly by Kubernetes for deployment

---

# MongoDB Database

- 3 replicas using StatefulSet
- ReplicaSet enabled
- Persistent storage using AWS EBS

✔ High Availability  
✔ Data persistence across pod restarts

---

# Key Design Principles

- Microservices separation
- High Availability (Multi-AZ)
- Auto Scaling (HPA)
- Fault tolerance
- Persistent storage (EBS)
- Cloud-native AWS integration

---

# Deployment Workflow

## 1. Provision Infrastructure (Terraform)

```bash
cd terraform
terraform init
terraform apply
```

Creates:

- VPC + Subnets
- EKS Cluster
- Node Groups
- IAM Roles

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


# Repository Structure

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

✔ Automatic scaling under load

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

# Storage Layer

- AWS EBS (Elastic Block Store)
- Kubernetes StorageClass (Dynamic provisioning)
- MongoDB StatefulSet persistence


---

# Key Highlights

- Fully deployed on AWS EKS
- Infrastructure as Code using Terraform
- Dockerized backend service
- Horizontal Auto Scaling (HPA)
- Stateful MongoDB ReplicaSet
- AWS ALB Ingress Controller integration
- High Availability & Fault Tolerance

---

# Notes

- AWS credentials required
- EKS must be deployed before Kubernetes manifests
- ALB is automatically created via controller
