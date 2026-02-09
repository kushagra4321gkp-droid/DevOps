# Terraform Remote State vs Usage — Q&A Guide

This README explains the **big picture** of why `remote_state/` and `usage/` exist, how they are connected, and why they are executed differently — **in a clear question–answer format**.

---

## ❓ Q1: I don’t understand the big picture. What is actually going on?

**Answer:**
You are working with **two completely separate Terraform projects**:

* **`remote_state/`** → Creates infrastructure *for Terraform itself* (S3 + DynamoDB)
* **`usage/`** → Creates your *actual AWS infrastructure* (EC2, VPC, RDS, etc.) and stores its state in that S3

They live in the same Git repo, but **Terraform treats them as unrelated projects**.

---

## ❓ Q2: Why does Terraform treat them as separate even though they are in the same repo?

**Answer:**
Terraform defines a *project* by the **working directory**, not by the Git repository.

```
terraform/aws/remote_state/   ← Project A
terraform/aws/usage/          ← Project B
```

Each folder has:

* its own `terraform init`
* its own state file
* its own lifecycle

They **cannot see each other’s `.tf` files**.

---

## ❓ Q3: What exactly is `remote_state/`?

**Answer:**
`remote_state/` is a **bootstrap project**.

Its only job is to create infrastructure that Terraform needs to work safely.

### What it creates

* S3 bucket → remote state storage
* DynamoDB table → state locking

### Files

```
remote_state/
├── main.tf      # creates S3 + DynamoDB
├── outputs.tf   # prints bucket & table names
└── README.md
```

---

## ❓ Q4: Why do we run `remote_state/` only once?

**Answer:**
Because:

* You need **one backend per account/environment**
* State storage should be **stable and permanent**

After running:

* S3 bucket exists
* DynamoDB table exists
* Terraform backend infrastructure is ready

⚠️ You only come back here if backend infrastructure itself must change.

---

## ❓ Q5: What exactly is `usage/`?

**Answer:**
`usage/` is where your **real AWS infrastructure** lives.

This is where you:

* create EC2, VPC, RDS, etc.
* deploy, update, and destroy resources many times

### Files

```
usage/
├── main.tf              # backend + provider
├── resources.tf         # REAL AWS resources
└── config/
    ├── backend-dev.conf # where remote state lives
    └── dev.tfvars       # environment values
```

---

## ❓ Q6: How is `usage/` connected to `remote_state/`?

**Answer:**
There is **no automatic Terraform connection**.

The connection is **manual and implicit**.

### Step 1: Get outputs from `remote_state/`

Example outputs:

```
s3_bucket_name      = 204844252504-terraform-states
dynamodb_table_name = terraform-lock
```

### Step 2: Copy them into `usage/config/backend-dev.conf`

```
bucket         = "204844252504-terraform-states"
key            = "dev/terraform.tfstate"
region         = "us-east-1"
dynamodb_table = "terraform-lock"
encrypt        = true
```

This file is the **bridge**.

Terraform never reads `outputs.tf` automatically — **you copy values once**.

---

## ❓ Q7: Why does `terraform init` behave differently in both folders?

**Answer:**

### In `remote_state/`

```
terraform init
terraform plan
terraform apply
```

✔ Creates backend infrastructure
✔ Run once

### In `usage/`

```
terraform init -backend-config=config/backend-dev.conf
```

This does **not** create AWS resources.

It only tells Terraform:

> “Store my state in this S3 bucket and lock it using DynamoDB.”

---

## ❓ Q8: Why can I run `plan` and `apply` many times in `usage/`?

**Answer:**
Because `usage/` manages **mutable infrastructure**:

* EC2, VPC, RDS change often
* State persists safely in S3
* DynamoDB prevents concurrent changes

You can safely run:

```
terraform plan
terraform apply
terraform destroy
terraform apply
```

---

## ❓ Q9: What is the correct mental model?

**Answer:**

```
remote_state/  = Terraform’s database
usage/         = Application using that database
```

You don’t rebuild the database every time.
You reuse it.

---

## ❓ Q10: Give me a one-line summary

**Answer:**

* `remote_state` → bootstrap once
* `usage` → real infrastructure, run many times
* connection → S3 + DynamoDB names copied manually
* separation → folder = Terraform project

