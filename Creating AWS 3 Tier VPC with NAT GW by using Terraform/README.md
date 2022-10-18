# Design a 3 Tier AWS VPC

## VPC information
- VPC Name: my-vpc
- Region: us-east-1
- IPv4 CIDR Block: 10.0.0.0/16
- Internet Gateway
- 1 NAT Gateway
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

## Terraform init

```
PS C:\Users\nhuth\Documents\terraform\3 Tier AWS VPC> terraform init

Initializing modules...
Downloading registry.terraform.io/terraform-aws-modules/vpc/aws 2.78.0 for vpc...
- vpc in .terraform\modules\vpc

Initializing the backend...

Initializing provider plugins...
- Finding hashicorp/aws versions matching ">= 2.70.0, ~> 3.0"...
- Installing hashicorp/aws v3.75.2...
- Installed hashicorp/aws v3.75.2 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```
## Terraform validate
```
PS C:\Users\nhuth\Documents\terraform\3 Tier AWS VPC> terraform validate
Success! The configuration is valid.
```

## Terraform plan

```
PS C:\Users\nhuth\Documents\terraform\3 Tier AWS VPC> terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the
following symbols:
  + create

#######output truncated######

Plan: 22 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + azs             = [
      + "us-east-1a",
      + "us-east-1b",
    ]
  + nat_public_ips  = [
      + (known after apply),
    ]
  + private_subnets = [
      + (known after apply),
      + (known after apply),
    ]
  + public_subnets  = [
      + (known after apply),
      + (known after apply),
    ]
  + vpc_cidr_block  = "10.0.0.0/16"
  + vpc_id          = (known after apply)
```

## Terraform apply
```
PS C:\Users\nhuth\Documents\terraform\3 Tier AWS VPC> terraform apply -auto-approve

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the
following symbols:
  + create

Terraform will perform the following actions:

  # module.vpc.aws_db_subnet_group.database[0] will be created
  + resource "aws_db_subnet_group" "database" {
      + arn         = (known after apply)
      + description = "Database subnet group for HR-stag-myvpc"
      + id          = (known after apply)
      + name        = "hr-stag-myvpc"
      + name_prefix = (known after apply)
      + subnet_ids  = (known after apply)
      + tags        = {
          + "Name"        = "HR-stag-myvpc"
          + "environment" = "stag"
          + "owners"      = "HR"
        }
      + tags_all    = {
          + "Name"        = "HR-stag-myvpc"
          + "environment" = "stag"
          + "owners"      = "HR"
        }
    }
    
###Output truncated######

module.vpc.aws_eip.nat[0]: Creating...
module.vpc.aws_vpc.this[0]: Creating...
module.vpc.aws_eip.nat[0]: Creation complete after 2s [id=eipalloc-0769dbef180c6e65f]
module.vpc.aws_vpc.this[0]: Still creating... [10s elapsed]
module.vpc.aws_vpc.this[0]: Still creating... [20s elapsed]
module.vpc.aws_vpc.this[0]: Creation complete after 23s [id=vpc-059827dbe231f122c]
module.vpc.aws_internet_gateway.this[0]: Creating...
module.vpc.aws_subnet.database[1]: Creating...     
module.vpc.aws_subnet.database[0]: Creating...     
module.vpc.aws_subnet.public[0]: Creating...       
module.vpc.aws_subnet.public[1]: Creating...       
module.vpc.aws_subnet.private[1]: Creating...      
module.vpc.aws_subnet.private[0]: Creating...      
module.vpc.aws_route_table.private[0]: Creating... 
module.vpc.aws_route_table.public[0]: Creating...  
module.vpc.aws_route_table.database[0]: Creating...
module.vpc.aws_route_table.public[0]: Creation complete after 3s [id=rtb-0658397a0ae41f292]
module.vpc.aws_route_table.database[0]: Creation complete after 3s [id=rtb-07d540114e6a47eb3]
module.vpc.aws_route_table.private[0]: Creation complete after 3s [id=rtb-09f113e80dca174f8]
module.vpc.aws_subnet.database[1]: Creation complete after 4s [id=subnet-0394ffbd98216e0fb]
module.vpc.aws_subnet.private[1]: Creation complete after 4s [id=subnet-0e2f738c15670abee]
module.vpc.aws_subnet.private[0]: Creation complete after 4s [id=subnet-04e2d23aef7f1cca8]
module.vpc.aws_route_table_association.private[1]: Creating...
module.vpc.aws_subnet.database[0]: Creation complete after 4s [id=subnet-08edb13a474056dad]
module.vpc.aws_route_table_association.private[0]: Creating...
module.vpc.aws_route_table_association.database[0]: Creating...
module.vpc.aws_route_table_association.database[1]: Creating...
module.vpc.aws_db_subnet_group.database[0]: Creating...
module.vpc.aws_internet_gateway.this[0]: Creation complete after 4s [id=igw-0b22dc4682a5a005d]
module.vpc.aws_route.public_internet_gateway[0]: Creating...
module.vpc.aws_route_table_association.private[0]: Creation complete after 3s [id=rtbassoc-055264da08a791ec1]
module.vpc.aws_route_table_association.database[0]: Creation complete after 3s [id=rtbassoc-0520e15b3e7863544]
module.vpc.aws_route_table_association.database[1]: Creation complete after 3s [id=rtbassoc-0992121a93eb46de3]
module.vpc.aws_route_table_association.private[1]: Creation complete after 3s [id=rtbassoc-0334787083b063251]
module.vpc.aws_db_subnet_group.database[0]: Creation complete after 4s [id=hr-stag-myvpc]
module.vpc.aws_route.public_internet_gateway[0]: Creation complete after 5s [id=r-rtb-0658397a0ae41f2921080289494]
module.vpc.aws_subnet.public[0]: Still creating... [10s elapsed]
module.vpc.aws_subnet.public[1]: Still creating... [10s elapsed]
module.vpc.aws_subnet.public[0]: Creation complete after 16s [id=subnet-05a4b9ca5f9f3f098]
module.vpc.aws_subnet.public[1]: Creation complete after 16s [id=subnet-0518247d2360907a6]
module.vpc.aws_route_table_association.public[1]: Creating...
module.vpc.aws_nat_gateway.this[0]: Creating...
module.vpc.aws_route_table_association.public[0]: Creating...
module.vpc.aws_route_table_association.public[0]: Creation complete after 4s [id=rtbassoc-008dd857d044e78c5]
module.vpc.aws_route_table_association.public[1]: Creation complete after 4s [id=rtbassoc-0fbcc16e5996214c8]
module.vpc.aws_nat_gateway.this[0]: Still creating... [10s elapsed]
module.vpc.aws_nat_gateway.this[0]: Still creating... [20s elapsed]
module.vpc.aws_nat_gateway.this[0]: Still creating... [30s elapsed]
module.vpc.aws_nat_gateway.this[0]: Still creating... [40s elapsed]
module.vpc.aws_nat_gateway.this[0]: Still creating... [50s elapsed]
module.vpc.aws_nat_gateway.this[0]: Still creating... [1m0s elapsed]
module.vpc.aws_nat_gateway.this[0]: Still creating... [1m10s elapsed]
module.vpc.aws_nat_gateway.this[0]: Still creating... [1m20s elapsed]
module.vpc.aws_nat_gateway.this[0]: Still creating... [1m30s elapsed]
module.vpc.aws_nat_gateway.this[0]: Still creating... [1m40s elapsed]
module.vpc.aws_nat_gateway.this[0]: Creation complete after 1m44s [id=nat-07ed85275f6d3c05b]
module.vpc.aws_route.private_nat_gateway[0]: Creating...
module.vpc.aws_route.private_nat_gateway[0]: Still creating... [10s elapsed]
module.vpc.aws_route.private_nat_gateway[0]: Creation complete after 11s [id=r-rtb-09f113e80dca174f81080289494]

Apply complete! Resources: 22 added, 0 changed, 0 destroyed.

Outputs:

azs = tolist([
  "us-east-1a",
  "us-east-1b",
])
nat_public_ips = tolist([
  "34.194.8.136",
])
private_subnets = [
  "subnet-04e2d23aef7f1cca8",
  "subnet-0e2f738c15670abee",
]
public_subnets = [
  "subnet-05a4b9ca5f9f3f098",
  "subnet-0518247d2360907a6",
]
vpc_cidr_block = "10.0.0.0/16"
vpc_id = "vpc-059827dbe231f122c"
PS C:\Users\nhuth\Documents\terraform\3 Tier AWS VPC>

```

## Verify the VPC created in AWS
![image](https://user-images.githubusercontent.com/67490369/196368662-3cfeb499-82a5-4040-bad7-fc4b1c7ca98b.png)


![image](https://user-images.githubusercontent.com/67490369/196367887-030b6808-c210-40f0-8e0c-f4b1f09b2a6a.png)


![image](https://user-images.githubusercontent.com/67490369/196368316-a9cf035f-07b4-4578-80b7-0806a81af5bc.png)


![image](https://user-images.githubusercontent.com/67490369/196368458-020f5c5c-caea-4fe2-b9c1-9067ee1da95d.png)


## Terraform destroy

```
PS C:\Users\nhuth\Documents\terraform\3 Tier AWS VPC> terraform destroy -auto-approve
module.vpc.aws_eip.nat[0]: Refreshing state... [id=eipalloc-0769dbef180c6e65f]
module.vpc.aws_vpc.this[0]: Refreshing state... [id=vpc-059827dbe231f122c]
module.vpc.aws_subnet.private[0]: Refreshing state... [id=subnet-04e2d23aef7f1cca8]
module.vpc.aws_subnet.private[1]: Refreshing state... [id=subnet-0e2f738c15670abee]
module.vpc.aws_route_table.database[0]: Refreshing state... [id=rtb-07d540114e6a47eb3]
module.vpc.aws_subnet.database[0]: Refreshing state... [id=subnet-08edb13a474056dad]
module.vpc.aws_subnet.database[1]: Refreshing state... [id=subnet-0394ffbd98216e0fb]
module.vpc.aws_route_table.public[0]: Refreshing state... [id=rtb-0658397a0ae41f292]
module.vpc.aws_internet_gateway.this[0]: Refreshing state... [id=igw-0b22dc4682a5a005d]
module.vpc.aws_route_table.private[0]: Refreshing state... [id=rtb-09f113e80dca174f8]
module.vpc.aws_subnet.public[1]: Refreshing state... [id=subnet-0518247d2360907a6]
module.vpc.aws_subnet.public[0]: Refreshing state... [id=subnet-05a4b9ca5f9f3f098]
module.vpc.aws_route.public_internet_gateway[0]: Refreshing state... [id=r-rtb-0658397a0ae41f2921080289494]
module.vpc.aws_route_table_association.public[0]: Refreshing state... [id=rtbassoc-008dd857d044e78c5]
module.vpc.aws_route_table_association.public[1]: Refreshing state... [id=rtbassoc-0fbcc16e5996214c8]
module.vpc.aws_nat_gateway.this[0]: Refreshing state... [id=nat-07ed85275f6d3c05b]
module.vpc.aws_db_subnet_group.database[0]: Refreshing state... [id=hr-stag-myvpc]
module.vpc.aws_route_table_association.database[0]: Refreshing state... [id=rtbassoc-0520e15b3e7863544]
module.vpc.aws_route_table_association.database[1]: Refreshing state... [id=rtbassoc-0992121a93eb46de3]
module.vpc.aws_route_table_association.private[0]: Refreshing state... [id=rtbassoc-055264da08a791ec1]
module.vpc.aws_route_table_association.private[1]: Refreshing state... [id=rtbassoc-0334787083b063251]
module.vpc.aws_route.private_nat_gateway[0]: Refreshing state... [id=r-rtb-09f113e80dca174f81080289494]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the
following symbols:
  - destroy

Terraform will perform the following actions:

  # module.vpc.aws_db_subnet_group.database[0] will be destroyed
  - resource "aws_db_subnet_group" "database" {
      - arn         = "arn:aws:rds:us-east-1:045177464321:subgrp:hr-stag-myvpc" -> null
      - description = "Database subnet group for HR-stag-myvpc" -> null
      - id          = "hr-stag-myvpc" -> null
      - name        = "hr-stag-myvpc" -> null
      - subnet_ids  = [
          - "subnet-0394ffbd98216e0fb",
          - "subnet-08edb13a474056dad",
        ] -> null
      - tags        = {
          - "Name"        = "HR-stag-myvpc"
          - "environment" = "stag"
          - "owners"      = "HR"
        } -> null
        
###Output truncated#####

module.vpc.aws_db_subnet_group.database[0]: Destroying... [id=hr-stag-myvpc]
module.vpc.aws_route_table_association.private[1]: Destroying... [id=rtbassoc-0334787083b063251]
module.vpc.aws_route.public_internet_gateway[0]: Destroying... [id=r-rtb-0658397a0ae41f2921080289494]
module.vpc.aws_route_table_association.public[0]: Destroying... [id=rtbassoc-008dd857d044e78c5]
module.vpc.aws_route_table_association.private[0]: Destroying... [id=rtbassoc-055264da08a791ec1]
module.vpc.aws_route_table_association.database[0]: Destroying... [id=rtbassoc-0520e15b3e7863544]
module.vpc.aws_route_table_association.database[1]: Destroying... [id=rtbassoc-0992121a93eb46de3]
module.vpc.aws_route_table_association.public[1]: Destroying... [id=rtbassoc-0fbcc16e5996214c8]
module.vpc.aws_route.private_nat_gateway[0]: Destroying... [id=r-rtb-09f113e80dca174f81080289494]
module.vpc.aws_db_subnet_group.database[0]: Destruction complete after 1s
module.vpc.aws_route_table_association.database[1]: Destruction complete after 3s
module.vpc.aws_route_table_association.public[0]: Destruction complete after 3s
module.vpc.aws_route_table_association.private[1]: Destruction complete after 3s
module.vpc.aws_route_table_association.public[1]: Destruction complete after 3s
module.vpc.aws_route_table_association.private[0]: Destruction complete after 3s
module.vpc.aws_route_table_association.database[0]: Destruction complete after 3s
module.vpc.aws_subnet.private[1]: Destroying... [id=subnet-0e2f738c15670abee]
module.vpc.aws_subnet.private[0]: Destroying... [id=subnet-04e2d23aef7f1cca8]
module.vpc.aws_route_table.database[0]: Destroying... [id=rtb-07d540114e6a47eb3]
module.vpc.aws_subnet.database[1]: Destroying... [id=subnet-0394ffbd98216e0fb]
module.vpc.aws_subnet.database[0]: Destroying... [id=subnet-08edb13a474056dad]
module.vpc.aws_route.private_nat_gateway[0]: Destruction complete after 4s
module.vpc.aws_nat_gateway.this[0]: Destroying... [id=nat-07ed85275f6d3c05b]
module.vpc.aws_route_table.private[0]: Destroying... [id=rtb-09f113e80dca174f8]
module.vpc.aws_route.public_internet_gateway[0]: Destruction complete after 4s
module.vpc.aws_route_table.public[0]: Destroying... [id=rtb-0658397a0ae41f292]
module.vpc.aws_subnet.private[0]: Destruction complete after 2s
module.vpc.aws_subnet.private[1]: Destruction complete after 2s
module.vpc.aws_subnet.database[0]: Destruction complete after 2s
module.vpc.aws_subnet.database[1]: Destruction complete after 2s
module.vpc.aws_route_table.database[0]: Destruction complete after 3s
module.vpc.aws_route_table.private[0]: Destruction complete after 3s
module.vpc.aws_route_table.public[0]: Destruction complete after 3s
module.vpc.aws_nat_gateway.this[0]: Still destroying... [id=nat-07ed85275f6d3c05b, 10s elapsed]
module.vpc.aws_nat_gateway.this[0]: Still destroying... [id=nat-07ed85275f6d3c05b, 20s elapsed]
module.vpc.aws_nat_gateway.this[0]: Still destroying... [id=nat-07ed85275f6d3c05b, 30s elapsed]
module.vpc.aws_nat_gateway.this[0]: Still destroying... [id=nat-07ed85275f6d3c05b, 40s elapsed]
module.vpc.aws_nat_gateway.this[0]: Still destroying... [id=nat-07ed85275f6d3c05b, 50s elapsed]
module.vpc.aws_nat_gateway.this[0]: Destruction complete after 56s
module.vpc.aws_internet_gateway.this[0]: Destroying... [id=igw-0b22dc4682a5a005d]
module.vpc.aws_subnet.public[0]: Destroying... [id=subnet-05a4b9ca5f9f3f098]
module.vpc.aws_eip.nat[0]: Destroying... [id=eipalloc-0769dbef180c6e65f]    
module.vpc.aws_subnet.public[1]: Destroying... [id=subnet-0518247d2360907a6]
module.vpc.aws_subnet.public[1]: Destruction complete after 2s
module.vpc.aws_subnet.public[0]: Destruction complete after 2s
module.vpc.aws_eip.nat[0]: Destruction complete after 3s
module.vpc.aws_internet_gateway.this[0]: Destruction complete after 3s
module.vpc.aws_vpc.this[0]: Destroying... [id=vpc-059827dbe231f122c]
module.vpc.aws_vpc.this[0]: Destruction complete after 2s

Destroy complete! Resources: 22 destroyed.
PS C:\Users\nhuth\Documents\terraform\3 Tier AWS VPC> 
```

```
PS C:\Users\nhuth\Documents\terraform\3 Tier AWS VPC> rm .\.terraform\ -r -force
PS C:\Users\nhuth\Documents\terraform\3 Tier AWS VPC> rm .\terraform*  
```
