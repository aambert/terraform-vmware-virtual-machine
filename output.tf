output "virtual_machine_names" {
  value = ["${flatten(list(
    vsphere_virtual_machine.bare.*.name,
    vsphere_virtual_machine.linux.*.name,
    vsphere_virtual_machine.windows.*.name,
  ))}"]
  description = "List of virtual machine names."
}

output "virtual_machine_addresses" {
  value = ["${flatten(list(
    vsphere_virtual_machine.bare.*.default_ip_address,
    vsphere_virtual_machine.linux.*.default_ip_address,
    vsphere_virtual_machine.windows.*.default_ip_address,
  ))}"]
  description = "List of virtual machine IPs."
}

output "virtual_machine_name_address_map" {
  value = "${zipmap(flatten(list(
    vsphere_virtual_machine.bare.*.name,
    vsphere_virtual_machine.linux.*.name,
    vsphere_virtual_machine.windows.*.name,
    )), flatten(list(
    vsphere_virtual_machine.bare.*.default_ip_address,
    vsphere_virtual_machine.linux.*.default_ip_address,
    vsphere_virtual_machine.windows.*.default_ip_address,
  )))}"
  description = "Map of virtual machine name w/ default ip address. Example: vm1 = 172.0.0.2, vm2 = 172.0.0.3"
}
