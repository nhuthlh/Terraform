# Design a 3 Tier AWS VPC

## VPC information
- VPC Name: my-vpc
- Region: us-east-1
- IPv4 CIDR Block: 10.0.0.0/16
- Internet Gateway
- 2 NAT GW in 2 AZs
- Availability zones = ["us-east-1a", "us-east-1b"]
- Public subnets = ["10.0.101.0/24", "10.0.102.0/24"]
- Private subnets = ["10.0.1.0/24", "10.0.2.0/24"]
- Database subnets= ["10.0.151.0/24", "10.0.152.0/24"]
- Routing table configuration

## Create the PVC using Terraform

Create VPC using Terraform Modules.

Define Input Variables for VPC module and reference them in VPC Terraform Module.

Define local values and reference them in VPC Terraform Module.

Create terraform.tfvars to load variable values by default from this file.

Create vpc.auto.tfvars to load variable values by default from this file related to a VPC.

Define Output Values for VPC
