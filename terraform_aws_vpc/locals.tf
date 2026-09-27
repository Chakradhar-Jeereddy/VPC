locals {
    common_tags = {
        Project = var.project
        Environment = var.environment
    }
    common_name_suffix = "${var.project}-${var.environment}" #roboshop-dev
    public_az = slice(data.aws_availability_zones.available.names, 0,2)
    private_az = slice(data.aws_availability_zones.available.names, 2,4)
    database_az = slice(data.aws_availability_zones.available.names, 4,6)
}

