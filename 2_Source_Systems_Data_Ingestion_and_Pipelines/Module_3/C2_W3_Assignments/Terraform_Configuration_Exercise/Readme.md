# 📘 Optional Terraform Exercise – Create a MySQL RDS in a Private Subnet

## 📝 Introduction
You’ve learned how to create an EC2 instance using Terraform.  
In this optional exercise, you will create a **MySQL RDS database instance** in Terraform.  
The goal is to **practice using Terraform and its documentation**.

---

## 🎯 Exercise Requirements

You are given:
- The **ID of a VPC** in the `us-east-1` region.
- The VPC contains **two private subnets** (IDs are not given).

You must:
1. Create a **MySQL RDS instance** inside one of the VPC's private subnets.
2. Discover subnet IDs dynamically (do not hardcode them).
3. Follow the given database specifications.

---

## ⚙️ Database Specifications

| Property                  | Value / Requirement                         |
|---------------------------|---------------------------------------------|
| Username                  | Variable with default `"admin_user"`        |
| Password                  | Variable with no default; set in `tfvars`   |
| Port                      | `3306`                                      |
| Instance Class            | `db.t3.micro`                               |
| Allocated Storage         | `10 GiB`                                    |
| Outputs                   | Hostname, username, password, port number   |

---

## 📚 Helpful Resources

- **aws_db_instance**  
  Arguments: [AWS Docs – aws_db_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance)  

- **aws_db_subnet_group**  
  Arguments: [AWS Docs – aws_db_subnet_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group)  

- **aws_subnets (data source)**  
  Attributes: [AWS Docs – aws_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets)  

---

## 🗂️ Suggested Project Structure
```
terraform_configuration_exercises/
├── main.tf
├── variables.tf
├── outputs.tf
└── terraform.tfvars
```

---
![image](../)

## 📄 Example Implementation

### `variables.tf`
```
variable "vpc_id" {
  description = "VPC ID where the RDS will be created"
  type        = string
}

variable "db_username" {
  description = "Master username for RDS"
  type        = string
  default     = "admin_user"
}

variable "db_password" {
  description = "Master password for RDS"
  type        = string
  sensitive   = true
}
```

### `main.tf`
```
provider "aws" {
  region = "us-east-1"
}

# 1. Get all subnets in the given VPC
data "aws_subnets" "selected" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

# 2. Create a subnet group for RDS (assumes these are private subnets)
resource "aws_db_subnet_group" "rds_group" {
  name       = "rds-private-subnet-group"
  subnet_ids = data.aws_subnets.selected.ids

  tags = {
    Name = "RDS Private Subnet Group"
  }
}

# 3. Create the MySQL RDS instance
resource "aws_db_instance" "mysql" {
  identifier           = "my-mysql-db"
  engine               = "mysql"
  instance_class       = "db.t3.micro"
  allocated_storage    = 10
  username             = var.db_username
  password             = var.db_password
  port                 = 3306
  db_subnet_group_name = aws_db_subnet_group.rds_group.name
  skip_final_snapshot  = true
  publicly_accessible  = false
}
```

### `outputs.tf`
```
output "db_hostname" {
  value = aws_db_instance.mysql.address
}

output "db_username" {
  value = var.db_username
}

output "db_password" {
  value     = var.db_password
  sensitive = true
}

output "db_port" {
  value = aws_db_instance.mysql.port
}
```

### `terraform.tfvars`
```
vpc_id      = "vpc-xxxxxxxx"
db_password = "StrongPasswordHere"
```

---

## 🚀 How to Run

1. **Initialize Terraform**
```
terraform init
```

2. **Preview changes**
```
terraform plan
```

3. **Apply configuration**
```
terraform apply
```

---

## 🧹 Cleanup
To avoid ongoing costs, destroy resources when done:
```
terraform destroy
```

---

## 🧠 Key Concepts Used

- **Data Source** (`aws_subnets`) → to dynamically fetch subnet IDs from a given VPC.
- **DB Subnet Group** → required for RDS to know where it can create the instance.
- **RDS Resource** (`aws_db_instance`) → creates the actual MySQL database instance.
- **Outputs** → return important connection details after creation.
