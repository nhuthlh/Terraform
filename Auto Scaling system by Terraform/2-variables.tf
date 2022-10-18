# Global variables
variable "region" {
  type        = string
  description = "AWS region"
  default = "us-east-1"
}

variable "publickey_directory" {
  type        = string
  description = "The directory of RSA private key created: /home/<user>/.ssh/id_rsa.pub"
}
variable "env" {
  type        = string
  description = "Enviroment: Dev/Test/UAT"
}

variable "project-name" {
  type        = string
  description = "Your project name"
}
# Launch configuration varibles
variable "launch-configuration-ami" {
  type        = string
  description = "Launch EC2 AMI"
}

variable "launch-configuration-instance-type" {
  type        = string
  description = "EC2 launchconfiguration instance type"
  default = "t2.micro"
}
