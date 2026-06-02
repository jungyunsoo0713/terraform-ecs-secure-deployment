terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 6.0"
        }
    }
}

provider "aws" {
    region = "ap-northeast-3"
}

resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
        Name = "terraform-ecs-secure-deployment-vpc"
    }
}

resource "aws_subnet" "public_subnet_1" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.0.0/24"
    map_public_ip_on_launch = true
    availability_zone = "ap-northeast-3a"
    tags = {
        Name = "terraform-ecs-secure-deployment-public-subnet-1"
    }
}

resource "aws_subnet" "public_subnet_2" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = true
    availability_zone = "ap-northeast-3c"
    tags = {
        Name = "terraform-ecs-secure-deployment-public-subnet-2"
    }
}

resource "aws_subnet" "private_subnet_1" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.10.0/24"
    map_public_ip_on_launch = false
    availability_zone = "ap-northeast-3a"
    tags = {
        Name = "terraform-ecs-secure-deployment-private-subnet-1"
    }
}

resource "aws_subnet" "private_subnet_2" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.11.0/24"
    map_public_ip_on_launch = false
    availability_zone = "ap-northeast-3c"
    tags = {
        Name = "terraform-ecs-secure-deployment-private-subnet-2"
    }
}

resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "terraform-ecs-secure-deployment-internet-gateway"
    }
}

resource "aws_eip" "nat" {
    domain = "vpc"

    tags = {
        Name = "terraform-ecs-secure-deployment-nat-eip"
    }
}

resource "aws_nat_gateway" "main" {
    allocation_id = aws_eip.nat.id
    subnet_id = aws_subnet.public_subnet_1.id

    depends_on = [aws_internet_gateway.main]

    tags = {
        Name = "terraform-ecs-secure-deployment-nat-gateway"
    }
}
