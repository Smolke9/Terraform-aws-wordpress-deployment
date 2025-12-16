# 🚀 WordPress on AWS using Terraform (Ubuntu)

This repository provisions a **WordPress server on AWS EC2 (Ubuntu)** using **Terraform**.
It installs **Apache, PHP, MySQL, and WordPress** automatically using a **user-data shell script**.

---

## 🏗️ Architecture

```
Internet
   |
EC2 (Ubuntu)
 ├── Apache
 ├── PHP
 ├── MySQL
 └── WordPress
```

---

## ✅ Prerequisites

Make sure the following are installed and configured:

- ✅ Terraform
- ✅ AWS CLI
- ✅ IAM Role attached to EC2 **OR** `aws configure` completed
- ✅ Existing AWS EC2 Key Pair (example: `ubuntuu.pem`)

### 🔍 Verify
```bash
aws sts get-caller-identity
terraform -version
```

---

## 📁 Project Structure

```
wordpress-terraform/
├── provider.tf
├── security.tf
├── main.tf
├── output.tf
├── userdata.sh
└── README.md
```

---

## 🧩 Step 1: Clone Repository

```bash
git clone https://github.com/your-username/wordpress-terraform.git
cd wordpress-terraform
```

---

## 🌍 Step 2: Configure Provider (`provider.tf`)

```hcl
provider "aws" {
  region = "ap-south-1"
}
```

---

## 🔐 Step 3: Security Group (`security.tf`)

Allows:
- SSH (22)
- HTTP (80)

```hcl
resource "aws_security_group" "wp_sg" {
  name        = "wordpress-sg"
  description = "Allow HTTP and SSH"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

---

## ⚙️ Step 4: User Data Script (`userdata.sh`)

```bash
#!/bin/bash
apt update -y

apt install apache2 php php-mysql mysql-server unzip wget -y

systemctl start apache2 mysql
systemctl enable apache2 mysql

mysql -e "CREATE DATABASE wpdb;"
mysql -e "CREATE USER 'wpuser'@'localhost' IDENTIFIED BY 'password';"
mysql -e "GRANT ALL PRIVILEGES ON wpdb.* TO 'wpuser'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

cd /var/www/html
wget https://wordpress.org/latest.zip
unzip latest.zip
chown -R www-data:www-data wordpress

cp wordpress/wp-config-sample.php wordpress/wp-config.php
sed -i "s/database_name_here/wpdb/" wordpress/wp-config.php
sed -i "s/username_here/wpuser/" wordpress/wp-config.php
sed -i "s/password_here/password/" wordpress/wp-config.php

systemctl restart apache2
```

---

## 🖥️ Step 5: EC2 Resource (`main.tf`)

```hcl
resource "aws_instance" "wordpress" {
  ami           = "ami-0f5ee92e2d63afc18"
  instance_type = "t2.micro"
  key_name      = "ubuntuu"

  security_groups = [aws_security_group.wp_sg.name]
  user_data       = file("userdata.sh")

  tags = {
    Name = "Terraform-WordPress"
  }
}
```

---

## 📤 Step 6: Output (`output.tf`)

```hcl
output "wordpress_url" {
  value = "http://${aws_instance.wordpress.public_ip}"
}
```

---

## 🚀 Step 7: Deploy Using Terraform

```bash
terraform init
terraform plan
terraform apply
```

Type:
```text
yes
```

---

## 🌐 Step 8: Access WordPress

```bash
terraform output
```

Open in browser:
```
http://EC2_PUBLIC_IP
```

🎉 WordPress setup screen will appear!

---

## 🔐 WordPress Database Details

```
Database Name: wpdb
Username: wpuser
Password: password
Host: localhost
```

---

## 🔑 SSH Access

```bash
chmod 400 ubuntuu.pem
ssh -i ubuntuu.pem ubuntu@EC2_PUBLIC_IP
```

---

## 🧹 Cleanup

```bash
terraform destroy
```

---

## 📌 Next Improvements

- 🔹 Nginx instead of Apache
- 🔹 WordPress 3-Tier Architecture
- 🔹 Auto Scaling + Load Balancer
- 🔹 RDS for MySQL
- 🔹 Dockerized WordPress

---

## 👨‍💻 Author

**Suraj Molke**  
AWS | Terraform | DevOps Learner

---

⭐ If you like this project, give it a star!
