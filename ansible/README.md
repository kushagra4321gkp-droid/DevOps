# Simple Ansible Nginx Setup

This is a **basic Ansible project** created for learning purposes. It demonstrates how to use Ansible to **install and restart Nginx** on EC2 instances using a simple playbook and an Ansible Galaxy role.

## 🧠 What I Learned / What This Repo Does

* Create EC2 instances on AWS
* Install Ansible on an Ubuntu machine
* Set up SSH key-based authentication
* Connect to remote instances using SSH
* Create an Ansible inventory and group hosts
* Write a simple Ansible playbook in YAML
* Create and use a role with Ansible Galaxy
* Install and restart Nginx using Ansible

## 🛠️ Setup Overview

1. Created **two EC2 instances (Ubuntu)**
2. Installed Ansible on one instance (control node)
3. Generated SSH keys using `ssh-keygen`
4. Copied the **public key (`~/.ssh/id_rsa.pub`)** to the other EC2 instance
5. Verified SSH access using:

```bash
ssh ubuntu@<target-instance-public-ip>
```

## 📦 Installing Ansible

On the control node:

```bash
sudo apt update
sudo apt install ansible -y
```

Check installation:

```bash
ansible --version
```

## 🔐 SSH Key Setup

Generate SSH keys:

```bash
ssh-keygen
```

Public key file used:

```text
~/.ssh/id_rsa.pub
```

Copy the public key to the target instance:

```bash
ssh-copy-id ubuntu@<target-instance-public-ip>
```

## 📁 Inventory File

An inventory file was created to list EC2 instance IPs and group them.

Example `inventory.ini`:

```ini
[web]
<ec2-public-ip>
```

Test connection:

```bash
ansible web -i inventory.ini -m ping
```

## ▶️ Playbook

A simple playbook was written to install and restart Nginx.

Example tasks:

* Install nginx
* Start nginx service
* Restart nginx when needed

Run the playbook:

```bash
ansible-playbook -i inventory.ini nginx.yml
```

## 🧩 Ansible Role

A role was created using Ansible Galaxy:

```bash
ansible-galaxy init nginx
```

The role handles:

* Installing Nginx
* Managing the Nginx service

## ✅ Result

After running the playbook:

* Nginx is installed on the target EC2 instance
* Nginx service is running
* Web server is accessible via browser using EC2 public IP

## 📌 Notes

* This project is intentionally simple
* No Ansible Vault or advanced configurations used
* Meant for beginners learning Ansible basics

## 📄 Author

Created while learning Ansible basics 🚀

