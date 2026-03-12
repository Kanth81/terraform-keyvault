Azure Key Vault Terraform Deployment

Overview
# Azure Key Vault Terraform Deployment

## Overview

This project provides an Infrastructure as Code (IaC) implementation using Terraform to deploy a production-ready Azure Key Vault.

The deployment follows security and operational best practices such as:

* RBAC-based access control
* Private networking using Private Endpoint
* Diagnostic logging to Log Analytics
* Environment-based configuration (Dev/Test/Prod)
* Terraform remote backend support

The goal is to create a reusable and secure Key Vault deployment that can be used across multiple environments.

---

## Architecture Overview

The Terraform configuration deploys the following Azure resources:

* Azure Resource Group
* Azure Key Vault
* Private Endpoint for Key Vault
* Private DNS Zone for private connectivity
* Role-Based Access Control (RBAC) assignments
* Diagnostic settings for monitoring and auditing

The Key Vault is configured to:

* Disable public network access
* Allow access only through Private Endpoints
* Enable RBAC authorization
* Enable soft delete and purge protection
* Send logs and metrics to Log Analytics

---

## Repository Structure

```
terraform-keyvault/
│
├── main.tf
├── variables.tf
├── outputs.tf
├── provider.tf
├── backend.hcl.example
├── terraform.tfvars.example
├── .gitignore
│
└── env
    ├── dev.tfvars
    ├── test.tfvars
    └── prod.tfvars
```

### File Description

| File                     | Purpose                                      |
| ------------------------ | -------------------------------------------- |
| main.tf                  | Defines Azure infrastructure resources       |
| variables.tf             | Declares Terraform input variables           |
| outputs.tf               | Exposes useful outputs such as Key Vault URI |
| provider.tf              | Configures the Azure provider                |
| terraform.tfvars.example | Example variable file                        |
| backend.hcl.example      | Example remote backend configuration         |
| env/*.tfvars             | Environment specific configurations          |

---

## Why Terraform was chosen

Terraform was selected because:

* It is cloud-agnostic and widely used for Infrastructure as Code
* It supports modular and reusable infrastructure
* It integrates easily with CI/CD pipelines
* It supports remote state management for team collaboration
* It enables consistent deployments across environments

---

## Production Readiness Design

The Key Vault configuration includes several production-grade features:

### 1. Secure Access Control

Azure RBAC is used to manage access to Key Vault instead of legacy access policies.

Roles used:

* Key Vault Administrator
* Key Vault Secrets Officer
* Key Vault Secrets User

This follows the principle of least privilege.

---

### 2. Private Network Access

Public network access to the Key Vault is disabled.

Access is only allowed through a Private Endpoint connected to a virtual network.

Benefits:

* Prevents internet exposure
* Ensures internal network access only
* Improves security posture

---

### 3. Diagnostic Logging

Diagnostic logs and metrics are sent to Log Analytics.

This enables:

* Security monitoring
* Audit trails
* Incident investigation
* Compliance reporting

---

### 4. Data Protection

The Key Vault is configured with:

* Soft delete enabled
* Purge protection enabled

This prevents accidental or malicious deletion of secrets.

---

## Secure Secret Injection Strategy

Secrets are **not stored in Terraform configuration**.

Instead, applications retrieve secrets securely from Azure Key Vault using **Managed Identity**.

### Managed Identity

Managed Identity provides an automatically managed identity for Azure services such as:

* Azure App Service
* Azure Functions
* AKS workloads

This identity is granted access to the Key Vault using RBAC.

This eliminates the need to store credentials in application code.

---

### Key Vault References

Azure App Service and Azure Functions support **Key Vault references** in application settings.

Example:

```
DB_PASSWORD = @Microsoft.KeyVault(SecretUri=https://myvault.vault.azure.net/secrets/db-password/)
```

At runtime:

1. The application authenticates using Managed Identity
2. Azure retrieves the secret from Key Vault
3. The secret is injected into the application configuration

This approach ensures secrets are never stored in source code or pipelines.

---

## Multi-Environment Strategy

The Terraform configuration supports multiple environments:

* Development
* Test
* Production

Each environment uses a separate variable file.

Example:

```
terraform plan -var-file=env/dev.tfvars
terraform plan -var-file=e
```

Benefits:

Environment isolation

Consistent infrastructure

Easier configuration management

In a production setup, each environment would also use separate:

remote Terraform state

Azure subscriptions or resource groups

CI/CD pipelines


Deployment Steps
Initialize Terraform
terraform init
Validate configuration
terraform validate
Review execution plan
terraform plan -var-file=env/dev.tfvars
Apply the deployment
terraform apply -var-file=env/dev.tfvars


Security Best Practices

The repository follows Terraform security best practices:

Terraform state files are excluded from Git

.tfvars files containing environment data are excluded

Secrets are stored only in Azure Key Vault

Access is managed through RBAC


Author

Lakshmikanth Talkad Nagaraju

DevOps / Cloud Engineer
