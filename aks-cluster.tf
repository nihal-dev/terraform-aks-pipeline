resource "azurerm_kubernetes_cluster" "HeadTestCluster" {
  name                = "HeadTest-Cluster"
  location            = var.location
  resource_group_name = azurerm_resource_group.az-rg-101-Training.name
  dns_prefix          = "HeadTest-Cluster-dns"
  sku_tier            = "Free"   ## it is used for AKS pricing tier in Azure portal
  kubernetes_version  = "1.25.6" ##sets the k8s version to be used
  #automatic_channel_upgrade = none   #automatic upgrades option in AKS
  #name of the auto generated RG for infrastructure resources managed by k8s as per the Azure portal naming convention
  node_resource_group = "MC_${var.rg_name}_HeadTest-Cluster"

  #Primary node pool section on azure portal
  default_node_pool {
    name                = "nodepool1"
    node_count          = 2 #if auto-scaling comes, then this value should be between min and max count!
    vm_size             = "Standard_B2s"
    enable_auto_scaling = false #autoscaling parameter in Terraform
    ###vm count for auto-scaling if set to true###
    ##max_count = 3
    ##min_count = 1
    ## if you need windows servers, then you need to use windows_profile, Linux is used by default
    ## os_sku --> for getting the image for your VM's
  }
  #you can setup username and ssh keys for login to the vm's
  #   linux_profile {
  #     admin_username = azureuser
  #     ssh_key {
  #         key_data = file()
  #     }
  #   }

  #you can use identity or service_principal for the azure aks to authenticate with other services but not both. 
  #there is no relation between service connection and the aks resource for terraform
  identity {
    type = "SystemAssigned"
  }

  #   service_principal {
  #     client_id     = var.client_id
  #     client_secret = var.client_secret
  #   }

  #network_profile {
  #  we can define the networking section in this part. you can have kubenet or azure cni. Need to study more in detail
  #}

}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.HeadTestCluster.kube_config.0.client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.HeadTestCluster.kube_config_raw
}