module "vpc" {
    source = "../terraform_aws_vpc"
    
    #cidr = "10.0.0.0/16"
    #tenancy = "default"
    #environment = "dev"
    #project = "roboshop"

    cidr = var.cidr
    tenancy = var.tenancy
    environment = var.environment
    project = var.project
    vpc_tags = var.vpc_tags
    public_cidr = var.public_cidr
    private_cidr = var.private_cidr
    database_cidr = var.database_cidr
}