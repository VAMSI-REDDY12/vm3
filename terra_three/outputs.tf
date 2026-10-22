output "task3_resource_group_name" {
  value = azurerm_resource_group.task3_rg.name
}

output "task3_load_balancer_public_ip" {
  value = azurerm_public_ip.task3_lb_public_ip.ip_address
}

output "task3_load_balancer_fqdn" {
  value = azurerm_public_ip.task3_lb_public_ip.fqdn
}

output "task3_web_vm_1_private_ip" {
  value = azurerm_network_interface.task3_web_nic_1.private_ip_address
}

output "task3_web_vm_2_private_ip" {
  value = azurerm_network_interface.task3_web_nic_2.private_ip_address
}

output "task3_web_vm_3_private_ip" {
  value = azurerm_network_interface.task3_web_nic_3.private_ip_address
}