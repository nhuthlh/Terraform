# Build an AWS Auto Scaling system by Terraform

## System design
- Use default VPC
- Application Load Balancer: HTTPS, HTTP redirected to HTTPS. Use self-signed X509 certificate created with openssl.
- Auto Scaling group: Min=1, Max=4, target scaling policy: CPU 60%, NetworkInput 600Mbps
- EC2 Launch configuration: t3.micro, 20G standard disk mount point /dev/sda1, user_data with nginx_install.sh will install NGINX, keypair name: myec2-key, private key saved on the local machine directory /home/your_user/.ssh/id_rsa.pub

## Generating the local X509 key (for ALB HTTPS)

**Create RSA private key**
```
nhuth@DESKTOP-2MKH2RH MINGW64 ~/Documents/terraform/Auto Scaling system
$ openssl genrsa 2048 > privatekey.pem
Generating RSA private key, 2048 bit long modulus (2 primes)
....................................+++++
................+++++
e is 65537 (0x010001)
```

**Create certificate signing request (CSR) from the private key, the file is used to submit to a certificate authority (CA) to apply for a digital server certificate.**
```
$ openssl req -new -key privatekey.pem -out csr.pem
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:VN
State or Province Name (full name) [Some-State]:HCMC
Locality Name (eg, city) []:HCMC
Organization Name (eg, company) [Internet Widgits Pty Ltd]:Home
Organizational Unit Name (eg, section) []:Dev
Common Name (e.g. server FQDN or YOUR name) []:www.home.net 
Email Address []:dev@home.net

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:.
An optional company name []:.
```

**Sign the certificate ourself instead of signing by a CA**
```
$ openssl x509 -req -days 365 -in csr.pem -signkey privatekey.pem -out public.c
rt
Signature ok
subject=C = VN, ST = HCMC, L = HCMC, O = Home, OU = Dev, CN = www.home.net, emailAddress = dev@home.net
Getting Private key

nhuth@DESKTOP-2MKH2RH MINGW64 ~/Documents/terraform/Auto Scaling system
$ ls
csr.pem  privatekey.pem  public.crt
```

## Create the RSA SSH key for EC2
```
$ ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/c/Users/nhuth/.ssh/id_rsa): 
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /c/Users/nhuth/.ssh/id_rsa
Your public key has been saved in /c/Users/nhuth/.ssh/id_rsa.pub
The key fingerprint is:
SHA256:nM8G1WnVnqILH8DwhN1kRmWBwCIfM3NPdsuP3oqmVns nhuth@DESKTOP-2MKH2RH
The key's randomart image is:
+---[RSA 3072]----+
|        +.==o+o. |
|     . O =o*.+  .|
|      o % = * ...|
|       o * o + ..|
|        S . . +  |
|         = + . . |
|          B = .  |
|         o =.E . |
|        ..o....  |
+----[SHA256]-----+
```

**Copy the SSH key and the TLS keys to the terraform directory.**

##Configure the AWS access keys to prepare for deployment
```
$ aws configure
AWS Access Key ID [****************IX6C]: AKIAZLIMTM3ZPTSY72F6
AWS Secret Access Key [****************df]: 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
Default region name [us-east-1]: 
Default output format [json]:
```

## Deployment with Terraform
```
$ terraform init

Initializing the backend...

Initializing provider plugins...
- Finding latest version of hashicorp/aws...
- Installing hashicorp/aws v4.35.0...
- Installed hashicorp/aws v4.35.0 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!
```

```
$ terraform validate
Success! The configuration is valid.
```

```
$ terraform plan
data.aws_availability_zones.all_available: Reading...
data.aws_availability_zones.all_available: Read complete after 1s [id=us-east-1]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols: 
  + create
 <= read (data resources)

Terraform will perform the following actions:

  # data.aws_subnets.default will be read during apply
  # (config refers to values not yet known)
 <= data "aws_subnets" "default" {
      + id   = (known after apply)
      + ids  = (known after apply)
      + tags = (known after apply)

      + filter {
          + name   = "vpc-id"
          + values = [
              + (known after apply),
            ]
        }

      + timeouts {
          + read = (known after apply)
        }
    }


#######################
Truncated
#######################


Plan: 13 to add, 0 to change, 0 to destroy.


Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform   
apply" now.
```

```
$ terraform apply -auto-approve
data.aws_availability_zones.all_available: Reading...
data.aws_availability_zones.all_available: Read complete after 1s [id=us-east-1]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols: 
  + create
 <= read (data resources)

Terraform will perform the following actions:

Plan: 13 to add, 0 to change, 0 to destroy.
aws_key_pair.ec2-key: Creating...
aws_iam_server_certificate.https-certification: Creating...
aws_default_vpc.default: Creating...
aws_key_pair.ec2-key: Creation complete after 1s [id=ec2-key]
aws_iam_server_certificate.https-certification: Creation complete after 1s [id=ASCAZLIMTM3ZC4AOGK3UC]
aws_default_vpc.default: Still creating... [10s elapsed]
aws_default_vpc.default: Creation complete after 16s [id=vpc-0aaf1a3859caa71fa]
data.aws_subnets.default: Reading...
aws_lb_target_group.auto-target-group: Creating...
aws_security_group.loadbalance-sg: Creating...
data.aws_subnets.default: Read complete after 0s [id=us-east-1]
aws_lb_target_group.auto-target-group: Creation complete after 3s [id=arn:aws:elasticloadbalancing:us-east-1:642660919026:targetgroup/TestBed/bca81fc33a34e52a]
aws_security_group.loadbalance-sg: Creation complete after 5s [id=sg-0146494d6ab98d0f6]
aws_lb.application-load-balancer: Creating...
aws_security_group.ec2-sg: Creating...
aws_security_group.ec2-sg: Creation complete after 4s [id=sg-070afd2c9ba53c3c0]
aws_launch_template.launch-configuration-template: Creating...
aws_launch_template.launch-configuration-template: Creation complete after 1s [id=lt-00426fce87ddd35fd]
aws_autoscaling_group.auto-scaling-group: Creating...
aws_lb.application-load-balancer: Still creating... [10s elapsed]
aws_autoscaling_group.auto-scaling-group: Still creating... [10s elapsed]
aws_lb.application-load-balancer: Still creating... [20s elapsed]
aws_autoscaling_group.auto-scaling-group: Still creating... [20s elapsed]
aws_autoscaling_group.auto-scaling-group: Creation complete after 23s [id=TestBed]
aws_autoscaling_policy.auto-scaling-policy-CPU: Creating...
aws_autoscaling_policy.auto-scaling-policy-BW: Creating...
aws_autoscaling_policy.auto-scaling-policy-CPU: Creation complete after 1s [id=CPU]
aws_lb.application-load-balancer: Still creating... [30s elapsed]
aws_autoscaling_policy.auto-scaling-policy-BW: Creation complete after 2s [id=BW]
aws_lb.application-load-balancer: Still creating... [40s elapsed]
aws_lb.application-load-balancer: Still creating... [50s elapsed]
aws_lb.application-load-balancer: Still creating... [1m0s elapsed]
aws_lb.application-load-balancer: Still creating... [1m10s elapsed]
aws_lb.application-load-balancer: Still creating... [1m20s elapsed]
aws_lb.application-load-balancer: Still creating... [1m30s elapsed]
aws_lb.application-load-balancer: Still creating... [1m40s elapsed]
aws_lb.application-load-balancer: Still creating... [1m50s elapsed]
aws_lb.application-load-balancer: Still creating... [2m0s elapsed]
aws_lb.application-load-balancer: Still creating... [2m10s elapsed]
aws_lb.application-load-balancer: Still creating... [2m20s elapsed]
aws_lb.application-load-balancer: Provisioning with 'local-exec'...
aws_lb.application-load-balancer (local-exec): Executing: ["cmd" "/C" "echo TestBed-1285792198.us-east-1.elb.amazonaws.com"]
aws_lb.application-load-balancer (local-exec): TestBed-1285792198.us-east-1.elb.amazonaws.com
aws_lb.application-load-balancer: Creation complete after 2m25s [id=arn:aws:elasticloadbalancing:us-east-1:642660919026:loadbalancer/app/TestBed/5c92ded21e7a0c4f]
aws_lb_listener.application-listener-https: Creating...
aws_lb_listener.application-listener-http: Creating...
aws_lb_listener.application-listener-https: Creation complete after 1s [id=arn:aws:elasticloadbalancing:us-east-1:642660919026:listener/app/TestBed/5c92ded21e7a0c4f/71ecb7abd30c00e1]
aws_lb_listener.application-listener-http: Creation complete after 2s [id=arn:aws:elasticloadbalancing:us-east-1:642660919026:listener/app/TestBed/5c92ded21e7a0c4f/8628cd97a7ebfafb]

Apply complete! Resources: 13 added, 0 changed, 0 destroyed.
```

## Verify the system after deployment, 1 EC2 instance in the ASG


![image](https://user-images.githubusercontent.com/67490369/196611968-ba448449-dbe1-42f7-98cd-737eea86441f.png)



## Stress the CPU to trigger auto scaling
```
[ec2-user@ip-172-31-5-131 ~]$ sudo stress --cpu 8
stress: info: [6343] dispatching hogs: 8 cpu, 0 io, 0 vm, 0 hdd
```
![image](https://user-images.githubusercontent.com/67490369/196611747-e92e5455-0ea3-4f49-855c-ddbe17447c28.png)


## The system adds another EC2

![image](https://user-images.githubusercontent.com/67490369/196611949-f0239b71-3891-4154-9e5a-bc8a0a7b7226.png)


