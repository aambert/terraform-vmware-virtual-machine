# VMware Virtual Machine Terraform module

Terraform module which creates Virtual Machine resources on VMware from scratch, or from a Windows or Linux template.

Usage example:

```
module "vms" {
  source  = "git::https://github.com/kheadjr/terraform-vmware-virtual-machine?ref=v1.0.1"

  datacenter = "dc1"
  cluster    = "cluster1"
  datastore  = "datastore1"

  folder = "Frontend"

  virtual_machine_instance_count     = 2
  virtual_machine_template_os_family = "windows"
  virtual_machine_template           = "win-2016-template"
  virtual_machine_name_prefix        = "web"

  virtual_machine_network_vlan = "VM Network"

  virtual_machine_network_address  = "192.168.0.0/24"
  virtual_machine_ip_address_start = 100
  virtual_machine_gateway          = "192.168.0.1"
  virtual_machine_dns_servers      = ["8.8.8.8", "1.1.1.1"]
}
```

## Inputs

| Name                               | Description                                                                                                                                                                    |  Type  |   Default    | Required |
| ---------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | :----: | :----------: | :------: |
| cluster                            | The name or absolute path to the cluster.                                                                                                                                      | string |     n/a      |   yes    |
| datacenter                         | The name of the datacenter. This can be a name or path. Can be omitted if there is only one datacenter in your inventory.                                                      | string |     n/a      |   yes    |
| datastore                          | The virtual machine configuration is placed here, along with any virtual disks that are created where a datastore is not explicitly specified.                                 | string |     n/a      |   yes    |
| virtual_machine_name_prefix        | The prefix name of the virtual machine to create. (max 12 characters)                                                                                                          | string |     n/a      |   yes    |
| virtual_machine_network_vlan       | The network VLAN to connect this interface to.                                                                                                                                 | string |     n/a      |   yes    |
| folder                             | The path to the folder to put this virtual machine in, relative to the datacenter that the resource pool is in.                                                                | string |     `""`     |    no    |
| resource_pool                      | The resource pool to put this virtual machine in.                                                                                                                              | string |     `""`     |    no    |
| virtual_machine_disk_size          | The size of the disk, in GiB. Used only in 'bare' virtual machine.                                                                                                             | string |    `"40"`    |    no    |
| virtual_machine_dns_servers        | Network interface-specific DNS server settings for Windows operating systems. On Linux operating systems this is global.                                                       |  list  |   `<list>`   |    no    |
| virtual_machine_gateway            | The IPv4 default gateway when using network_interface customization on the virtual machine.                                                                                    | string |     `""`     |    no    |
| virtual_machine_guest_id           | The guest ID for the operating system type. Full list - https://pubs.vmware.com/vsphere-6-5/topic/com.vmware.wssdk.apiref.doc/vim.vm.GuestOsDescriptor.GuestOsIdentifier.html  | string | `"other-64"` |    no    |
| virtual_machine_instance_count     | The desired amount of virtual machines to create. Default: 1                                                                                                                   | string |    `"1"`     |    no    |
| virtual_machine_ip_address_start   | Creates an IP address with the given host number. (example: If value is 50 and network address is 172.27.0.0/24 then the IP is 172.27.0.50 ).                                  | string |     `""`     |    no    |
| virtual_machine_linked_clone       | Clone this virtual machine from a snapshot. Templates must have a single snapshot only in order to be eligible.                                                                | string |  `"false"`   |    no    |
| virtual_machine_memory             | The virtual machine memory, in GB. Default: 2                                                                                                                                  | string |    `"2"`     |    no    |
| virtual_machine_network_address    | The IPv4 network address in CIDR notation. (example: 172.27.0.0/24)                                                                                                            | string |     `""`     |    no    |
| virtual_machine_num_cpus           | The number of CPUs to assign to the virtual machine. Default: 1                                                                                                                | string |    `"1"`     |    no    |
| virtual_machine_scsi_type          | The type of SCSI bus this virtual machine will have. Can be one of lsilogic (LSI Logic Parallel), lsilogic-sas (LSI Logic SAS) or pvscsi (VMware Paravirtual). Defualt: pvscsi | string |  `"pvscsi"`  |    no    |
| virtual_machine_tags               | Tags to assign the virtual machine.                                                                                                                                            |  list  |   `<list>`   |    no    |
| virtual_machine_template           | The name of the virtual machine template.                                                                                                                                      | string |     `""`     |    no    |
| virtual_machine_template_os_family | Should be one of 'linux' or 'windows'. Leave blank to create a virtual machine from scratch.                                                                                   | string |     `""`     |    no    |
| windows_administrator_password     | Local Administrator password.                                                                                                                                                  | string |     `""`     |    no    |
| windows_run_once_command_list      | Commands that will be executed during OS customization phase.                                                                                                                  |  list  |   `<list>`   |    no    |

## Outputs

| Name                             | Description                                                                                  |
| -------------------------------- | -------------------------------------------------------------------------------------------- |
| virtual_machine_addresses        | List of virtual machine IPs.                                                                 |
| virtual_machine_name_address_map | Map of virtual machine name w/ default ip address. Example: vm1 = 172.0.0.2, vm2 = 172.0.0.3 |
| virtual_machine_names            | List of virtual machine names.                                                               |
