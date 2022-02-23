
terraform init
# 下载依赖项

terraform fmt
# 格式化.tf 文件

terraform apply
# terraform apply -var "vpc_name=YetAnotherName" 指定变量
# 创建资源

terraform show
# 检查状态
# 应用配置时，Terraform 将数据写入名为 terraform.tfstate. Terraform 将其管理的资源的 ID 和属性存储在此文件中，以便以后可以更新或销毁这些资源。

terraform output
# 查询输出

terraform destroy
# 删除资源



resource "azurerm_subnet" "subnet" {
    name                 = "royTFSubnet"
    resource_group_name  = "${azurerm_resource_group.rg.name}"
    virtual_network_name = "${azurerm_virtual_network.vnet.name}"
    address_prefix       = "10.0.1.0/24"
    #address_prefix       = "${cidrsubnet(var.cluster_cidr, 8, 10)}"
}

# DataSource 的作用可以通过输入一个资源的变量名，然后获得这个变量的其他属性字段
data "azurerm_virtual_network" "test" {
  name                = "production"
  resource_group_name = "networking"
}

# Data 可用挂在远程state
output "cluster_arn" {
  description = "MSK Cluster ARN"
  value       = aws_msk_cluster.msk.arn
}
data "terraform_remote_state" "backend" {
  backend = "s3"

  config = {
    region  = data.aws_region.current.name
    bucket  = "tf-state-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}"
    key     = "customer-portal/${var.prefix}/${data.aws_region.current.name}/backend.tfstate"
    profile = "${data.aws_caller_identity.current.account_id}_UserFull"
  }
}
current_cluster_arn                  = data.terraform_remote_state.backend.outputs.cluster_arn
