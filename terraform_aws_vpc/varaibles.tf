variable "cidr" {
    type = string 
}

variable "tenancy" {
    type = string
}

variable "tags" {
    type = map
    default = {}
}

variable "project" {
    type = string
}

variable "environment" {
    type  = string
}

#tag name should be project_name-environment-resource_name


#want to add more tags

variable "vpc_tags" {
    default = {}
    type = map
}

variable "igw_tags" {
    default = {}
    type = map
}

variable "public_cidr" {
    type = list 
}

variable "private_cidr" {
    type = list
}

variable "database_cidr" {
    type = list
}

variable "route_tags" {
    default = {}
    type = map
}