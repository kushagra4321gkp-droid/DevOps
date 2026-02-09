# Terraform Project README — Complete Big Picture

This README consolidates **all discussions** and explains the Terraform setup, concepts, workflow, and mental model used across this repository.

---

## 1️⃣ What This Repository Represents

This repo demonstrates a **clean, production-style Terraform layout** where:

* Terraform state is stored **remotely and safely**
* Infrastructure can be **created, changed, and destroyed repeatedly**
* Backend infrastructure is **bootstrapped only once**

---

## 2️⃣ Core Terraform Concept (Very Important)

> **Terraform defines a project by folder, not by Git repository.**

Each directory where you run `terraform init` is an **independent Terraform project** with:

* its own state
* its own lifecycle
* its own backend

---

## 3️⃣ Folder Structure (High Level)

```
terraform/
└── aws/
    ├── remote_state/
    └── usage/
```

These are **two separate Terraform projects**.

---

## 4️⃣ Project 1: `remote_state/`

### Purpose

`remote_state/` exists to create infrastructure **for Terraform itself**.

It bootstraps:

* **S3 bucket** → remote Terraform state storage
* **DynamoDB table** → state locking (prevents concurrent applies)

This is foundational infrastructure.

---

### Files

```
remote_state/
├── main.tf      # Creates S3 + DynamoDB
├── outputs.tf   # Exposes bucket & table names
└── README.md
```

---

### Lifecycle

```
terraform init
terraform plan
terraform apply
```

✔ Run **once per AWS account / environment**
❌ Do not run repeatedly unless backend infra must change

After this runs:

* Terraform state storage exists
* Locking mechanism exists
* Backend is ready for all other projects

---

## 5️⃣ Project 2: `usage/`

### Purpose

`usage/` manages **real AWS infrastructure** such as:

* EC2
* VPC
* RDS
* IAM

This project is expected to:

* change frequently
* be applied many times
* be destroyed and recreated

---

### Files

```
usage/
├── main.tf              # Backend + provider configuration
├── resources.tf         # Actual AWS resources
└── config/
    ├── backend-dev.conf # Remote backend configuration
    └── dev.tfvars       # Environment variables
```

---

## 6️⃣ How `remote_state` and `usage` Are Connected

There is **NO direct Terraform dependency** between them.

The connection is **manual and intentional**.

### Step 1 — Run `remote_state/` once

This produces outputs like:

```
s3_bucket_name      = 204844252504-terraform-states
dynamodb_table_name = terraform-lock
```

### Step 2 — Copy values into `usage/config/backend-dev.conf`

```
bucket         = "204844252504-terraform-states"
key            = "dev/terraform.tfstate"
region         = "us-east-1"
dynamodb_table = "terraform-lock"
encrypt        = true
```

Terraform never reads `outputs.tf` automatically.
You copy these values **once**.

---

## 7️⃣ Why `terraform init` Behaves Differently

### In `remote_state/`

```
terraform init
terraform plan
terraform apply
```

✔ Creates backend infrastructure
✔ Executed once

---

### In `usage/`

```
terraform init -backend-config=config/backend-dev.conf
```

This does **not** create AWS resources.

It only tells Terraform:

> Where to store state and how to lock it

Run again only if backend configuration changes.

---

## 8️⃣ Why `usage/` Can Be Applied Many Times

Because:

* Infrastructure is mutable
* State persists remotely in S3
* DynamoDB prevents concurrent execution

Safe operations:

```
terraform plan
terraform apply
terraform destroy
terraform apply
```

---

## 9️⃣ Environment Handling

* `backend-dev.conf` → backend-specific values (state location)
* `dev.tfvars` → environment-specific variables (CIDR, instance type, etc.)

This enables:

* multiple environments (dev, qa, prod)
* same Terraform code, different values

---

## 🔟 Mental Model (Remember This)

```
remote_state/  = Terraform’s database
usage/         = Application using that database
```

You do not rebuild the database every time.
You reuse it.

---

## 1️⃣1️⃣ Key Rules to Remember

* Folder = Terraform project
* Backend infra is stable and long-lived
* Application infra is dynamic
* State must always be remote in teams
* Outputs are for humans, not automation

---

## 1️⃣2️⃣ Final Summary

* `remote_state/` → bootstrap, run once
* `usage/` → real infrastructure, run many times
* connection → manual via backend config
* separation → enforced by Terraform design

---

✅ This structure is **production-grade**, **interview-safe**, and **industry standard**.

