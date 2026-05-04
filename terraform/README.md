# 🚀 AWS Infrastructure Provisioning using Terraform

This project provisions a scalable and production-like AWS infrastructure using Terraform.  
It focuses on building a solid foundation for containerized and Kubernetes-based workloads.

---

# 🏗️ What This Terraform Project Creates

The infrastructure includes:

- VPC (custom CIDR, DNS enabled)
- Public & Private Subnets across multiple AZs
- Internet Gateway
- NAT Gateway for private subnet access
- Route Tables and Associations
- Security Groups
- EKS Cluster (Managed Kubernetes control plane)
- EKS Managed Node Groups
- IAM Roles and Policies for EKS


---

# 🏗️ Architecture Overview

Terraform (VPC + EKS) → Outputs → Helm (K8s Addons)

---

# 📁 Project Structure

terraform/
├── main.tf
├── providers.tf
├── variables.tf
├── outputs.tf
├── backend.tf
│
├── modules/
│   ├── vpc/
│   └── eks/
│
├── helm/
│   ├── main.tf
│   ├── remote-state.tf
│   ├── metrics-server.tf
│   ├── aws-load-balancer-controller.tf
│   └── versions.tf

---

# ⚙️ Prerequisites

- AWS Account
- AWS CLI configured (aws configure)
- Terraform >= 1.5
- kubectl installed
- Helm installed
- Proper IAM permissions (EKS, VPC, IAM, EC2)

---

# 🚀 Deployment Steps

## 1. Initialize Terraform
cd terraform
terraform init  

---

## 2. Validate Configuration
terraform validate  

---

## 3. Plan Infrastructure
terraform plan  

---

## 4. Apply Infrastructure (VPC + EKS)
terraform apply  

Creates:
- VPC with public/private subnets
- NAT Gateway
- EKS Cluster
- Node Groups
- IAM Roles & Security Groups

---

## 5. Configure kubectl
aws eks update-kubeconfig --region us-east-1 --name backend-eks  

---

## 6. Deploy Helm Addons
cd helm  
terraform init  
terraform apply  

Deploys:
- Metrics Server (HPA support)
- AWS Load Balancer Controller (Ingress support)

---

# 📊 Terraform Outputs

- VPC ID
- Private Subnets
- EKS Cluster Name
- EKS Endpoint
- Cluster CA Certificate

Used automatically by Helm via terraform_remote_state.

---

# 🌐 Ingress

AWS Load Balancer Controller:
- Creates ALB automatically
- Routes external traffic to services
- Integrates with AWS VPC

---

# 🧠 Design Highlights

- Modular Terraform architecture  
- Reusable VPC and EKS modules  
- Multi-AZ high availability design  
- Secure private/public networking  
- Scalable cloud-native foundation  

---

# 🧪 Load Testing

seq 1 20000 | xargs -n1 -P100 curl -s http://backend.local/posts > /dev/null  

---

# 🧠 Design Highlights

- Modular Terraform architecture
- Separation of infra and platform layers
- Remote state integration between layers
- Production-like scalable design

---

# ⚠️ Notes

- AWS credentials must be configured
- kubeconfig must be updated after EKS creation
- Helm depends on successful infra deployment

