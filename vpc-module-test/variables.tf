variable "cidr" {
  default = "10.0.0.0/16"
}

variable "project" {
    default = "roboshop"
}

variable "environment" {
    default = "dev"
}

variable "tenancy" {
    default = "default"
}

variable "vpc_tags" {
    default = {
        purpose = "to test module"
        deleteaftertest = "true"
    }
}

variable "public_cidr" {
    type = list 
    default = [ "10.0.1.0/24" , "10.0.2.0/24"]
}

variable "private_cidr" {
    type = list
    default = [ "10.0.11.0/24" , "10.0.12.0/24"]
}

variable "database_cidr" {
    type = list
    default = [ "10.0.21.0/24" , "10.0.22.0/24"]
}