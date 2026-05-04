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

# Architecture

```
User → AWS ALB (Ingress)
     → Kubernetes Service (ClusterIP)
     → Backend Pods (Deployment + HPA)
     → MongoDB ReplicaSet (3 StatefulSet Pods)
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

# Required Demo (Submission)

The recorded video includes:

- AWS infrastructure overview (Terraform)
- Kubernetes deployment on EKS
- Live API access via ALB
- Auto-scaling demonstration (HPA)
- Pod failure recovery test
- MongoDB resilience test

---

# Notes

- AWS credentials required
- EKS cluster must be created before Kubernetes deployment
- ALB is automatically provisioned via AWS Load Balancer Controller
