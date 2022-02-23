terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

# 配置文件
provider "aws" {
  profile = "private"
  region  = "us-east-2"
}

# 创建VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
#    Name = "tf-example"
    Name = var.vpc_name
  }
}


# data 可以读取文件也可以获取指定条件云资源
data "aws_vpc" "data_select_vpc" {
  id              = var.vpc_id
}
#output "out_data_vpc_id" {
#  value = "${data.aws_vpc.data_select_vpc.id}"
#}
#output "out_data_vpc" {
#  value = "${data.aws_vpc.data_select_vpc}"
#}


resource "aws_security_group" "my_sg" {
  vpc_id = data.aws_vpc.data_select_vpc.id
  
}

# 输出创建的资源,可以放到outputs.tf 文件中
output "out_vpc" {
  value = aws_vpc.my_vpc
}
output "out_sg" {
  value = aws_security_group.my_sg
}





