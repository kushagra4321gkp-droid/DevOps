# Terraform EC2 Creation & Variables — Q&A README

This README explains **how to create an EC2 instance using Terraform** and clarifies the roles of `backend-dev.conf`, `dev.tfvars`, and `variables.tf` using a **clear question–answer format**.

---

## ❓ Q1: What is the difference between `backend-dev.conf` and `dev.tfvars`?

### `config/backend-dev.conf`

**Answer:**

* Used by **Terraform itself**
* Configures **where Terraform state is stored**
* Read **only during `terraform init`**

Contains:

* S3 bucket name
* State key
* AWS region
* DynamoDB table

👉 Not variables
👉 Not accessible inside `.tf` files

---

### `config/dev.tfvars`

**Answer:**

* Used by **your infrastructure code**
* Supplies values to input variables (`var.*`)
* Read during **`terraform plan` and `terraform apply`**

Contains:

* AMI ID
* instance type
* key name
* tags

👉 Controls **what resources get created**

---

### One-line difference

```
backend-dev.conf = state storage config
dev.tfvars       = environment values
```

---

## ❓ Q2: What does “environment values” mean?

**Answer:**
Environment values are **inputs that change between environments** (dev / test / prod) while keeping Terraform code the same.

### What stays the same

* `.tf` files (architecture, resources, security)

### What changes

* sizes
* capacity
* naming
* limits

---

### Example

Same code:

```hcl
instance_type = var.instance_type
```

Different environments:

**`dev.tfvars`**

```hcl
instance_type = "t2.micro"
```

**`prod.tfvars`**

```hcl
instance_type = "t3.large"
```

⚠️ These are **not OS environment variables** (`export VAR=value`).

---

## ❓ Q3: How do I create an EC2 instance using `resources.tf`?

### Step 1 — Add EC2 resource

**`resources.tf`**

```hcl
resource "aws_instance" "dev_ec2" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  tags = {
    Name = var.instance_name
    Env  = "dev"
  }
}
```

---

## ❓ Q4: Where do variables come from?

### `variables.tf` (declaration)

**Answer:**
This file defines **what inputs are allowed**.

```hcl
variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}

variable "instance_name" {
  type = string
}
```

---

## ❓ Q5: Where do variable values go?

### `config/dev.tfvars` (assignment)

**Answer:**
This file supplies **actual values** for a specific environment.

```hcl
ami_id         = "ami-0abcdef1234567890"  # valid for your region
instance_type = "t2.micro"
key_name      = "my-ec2-key"
instance_name = "dev-ec2"
```

---

## ❓ Q6: What is the correct command sequence?

```bash
terraform init  -backend-config=config/backend-dev.conf
terraform plan  -var-file=config/dev.tfvars
terraform apply -var-file=config/dev.tfvars
```

---

## ❓ Q7: Why did Terraform say “No changes”?

**Answer:**
This output is **100% correct** when:

* No resources exist yet, OR
* `terraform apply` was run **without `-var-file`**

Terraform had nothing to create.

---

## ❓ Q8: Why is `terraform state list` empty?

**Answer:**

* State **does exist** (remote backend is active)
* But it contains **0 managed resources**

`terraform state list` only shows **created resources**.

Empty output = expected.

---

## ❓ Q9: How can I verify state is really remote?

Choose one:

1️⃣ Check your S3 bucket → state file exists

2️⃣ Create a resource:

```bash
terraform apply -var-file=config/dev.tfvars
```

Then:

```bash
terraform state list
```

---

## ❓ Q10: Is `variables.tf` the same as `dev.tfvars`?

**Answer:** ❌ No.

### Key difference

```text
variables.tf  → declares variables (rules)
dev.tfvars    → assigns values (data)
```

### Analogy

```
variables.tf → function parameters
dev.tfvars   → arguments passed to the function
```

---

## ❓ Q11: Can anyone customize the project using `dev.tfvars`?

**Answer:** ✅ Yes — that’s the design.

### People can change

* instance size
* AMI
* counts
* tags

### People cannot change

* architecture
* resource types
* security logic

---

## ❓ Q12: Why this pattern is powerful

* Same Terraform code
* Multiple environments
* Safe customization boundary

**Real-world pattern:**

```
Terraform code → platform team
tfvars files  → app / env teams
```

---

## 🔐 Security Note

❌ Never store secrets in `*.tfvars`

Use:

* environment variables
* AWS Secrets Manager
* Parameter Store

---

## ✅ One-line Final Takeaway

> **Terraform code defines the design; tfvars define the behavior per environment.**

