# Infrastructure Deployment using Terraform and Terragrunt

## Overview
This repository contains Terraform and Terragrunt configurations to deploy infrastructure components required for a Kubernetes (K8s) cluster, including Keyvault, Service Principal, and the ArgoCD application delivery tool. Additionally, it includes configurations for deploying applications using ArgoCD, managing rollouts with a canary deployment strategy, and onboarding applications to the K8s cluster using Helm charts.

## Folder Structure
- `terraform/`: Contains modules and sub-modules for installing the K8s cluster, Keyvault, Service Principal, and the ArgoCD application 
- `terragrunt/`: Contains configurations for global providers, subscriptions, regions, and environment variables. 
  - `regions/`: Contains environment input files (`prod`, `develop`, `test`) with configurations specific to each environment.

## Components
1. Terraform used to provision infrastructure components such as the K8s cluster, Keyvault, and Service Principal.
2. Terragrunt sed for managing global configurations, subscriptions, regions, and environment-specific variables.
3. Deploying applications to the K8s cluster.
4. Configuration to create projects within ArgoCD 
5. Configuration for managing application rollouts with a canary deployment strategy.
6. Helm chart for onboarding applications to the K8s cluster

Proposal: Deployment with Atlantis and Terragrunt

1. Make changes to the Terraform or Terragrunt configurations in feature branches.
2. A new merge request (MR) is created to propose the changes.
3. Atlantis automatically runs terragrunt plan 
4. Review the plan , MR 
5. Once the MR is approved and Atlantis automatically executes terragrunt apply
6. The changes are merged into the master branch.
 

Proposal: Infrastructure Automation with HashiCorp Vault

To enhance security and manage secrets for Kubernetes applications, integrating HashiCorp Vault. Secret Management for Kubernetes Apps, Terraform to fetch secrets from Vault via Approle authentication (machine-to-machine) and OIDC euthentication for users. 

**Backup and Restore**: Implement a cron job in Kubernetes to periodically backup the Vault data and store it in storage account. 