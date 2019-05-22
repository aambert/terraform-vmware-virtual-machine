output "virtual_machine_names" {
  value       = "${vsphere_virtual_machine.vm.*.name}"
  description = "List of virtual machine names."
}

output "virtual_machine_addresses" {
  value       = "${vsphere_virtual_machine.vm.*.default_ip_address}"
  description = "List of virtual machine IPs."
}

output "virtual_machine_name_address_map" {
  value       = "${zipmap(vsphere_virtual_machine.vm.*.name, vsphere_virtual_machine.vm.*.default_ip_address)}"
  description = "Map of virtual machine name w/ default ip address. Example: vm1 = 172.0.0.2, vm2 = 172.0.0.3"
}
