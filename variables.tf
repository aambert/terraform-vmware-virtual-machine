variable "datacenter" {
  description = "The name of the datacenter. This can be a name or path. Can be omitted if there is only one datacenter in your inventory."
  type        = "string"
}

variable "cluster" {
  description = "The name or absolute path to the cluster."
  type        = "string"
}

variable "datastore" {
  description = "The virtual machine configuration is placed here, along with any virtual disks that are created where a datastore is not explicitly specified."
  type        = "string"
}

variable "resource_pool" {
  description = "The resource pool to put this virtual machine in."
  type        = "string"
  default     = ""
}
variable "folder" {
  description = "The path to the folder to put this virtual machine in, relative to the datacenter that the resource pool is in."
  type        = "string"
  default     = ""
}

variable "virtual_machine_template" {
  description = "The name of the virtual machine template."
  type        = "string"
  default     = ""
}

variable "virtual_machine_template_os_family" {
  description = "Should be one of 'linux' or 'windows'. Leave blank to create a virtual machine from scratch."
  type        = "string"
  default     = ""
}

variable "virtual_machine_guest_id" {
  description = "The guest ID for the operating system type. Full list - https://pubs.vmware.com/vsphere-6-5/topic/com.vmware.wssdk.apiref.doc/vim.vm.GuestOsDescriptor.GuestOsIdentifier.html"
  type        = "string"
  default     = "other-64"
}

variable "virtual_machine_scsi_type" {
  description = "The type of SCSI bus this virtual machine will have. Can be one of lsilogic (LSI Logic Parallel), lsilogic-sas (LSI Logic SAS) or pvscsi (VMware Paravirtual). Defualt: pvscsi"
  type        = "string"
  default     = "pvscsi"
}

variable "virtual_machine_disk_size" {
  description = "The size of the disk, in GiB. Used only in 'bare' virtual machine."
  type        = "string"
  default     = "40"
}

variable "virtual_machine_name_prefix" {
  description = "The prefix name of the virtual machine to create. (max 12 characters)"
  type        = "string"
}

variable "virtual_machine_instance_count" {
  description = "The desired amount of virtual machines to create. Default: 1"
  type        = "string"
  default     = 1
}

variable "virtual_machine_num_cpus" {
  description = "The number of CPUs to assign to the virtual machine. Default: 1"
  type        = "string"
  default     = 1
}

variable "virtual_machine_memory" {
  description = "The virtual machine memory, in GB. Default: 2"
  type        = "string"
  default     = 2
}

variable "virtual_machine_network_vlan" {
  description = "The network VLAN to connect this interface to."
  type        = "string"
}

variable "virtual_machine_network_address" {
  description = "The IPv4 network address in CIDR notation. (example: 172.27.0.0/24)"
  type        = "string"
  default     = ""
}

variable "virtual_machine_ip_address_start" {
  description = "Creates an IP address with the given host number. (example: If value is 50 and network address is 172.27.0.0/24 then the IP is 172.27.0.50 )."
  type        = "string"
  default     = ""
}

variable "virtual_machine_gateway" {
  description = "The IPv4 default gateway when using network_interface customization on the virtual machine."
  type        = "string"
  default     = ""
}

variable "virtual_machine_dns_servers" {
  description = "Network interface-specific DNS server settings for Windows operating systems. On Linux operating systems this is global."
  type        = "list"
  default     = []
}

variable "virtual_machine_tags" {
  description = "Tags to assign the virtual machine."
  type        = "list"
  default     = []
}

variable "virtual_machine_linked_clone" {
  description = "Clone this virtual machine from a snapshot. Templates must have a single snapshot only in order to be eligible."
  type        = "string"
  default     = false
}

# Windows Customization
variable "windows_administrator_password" {
  description = "Local Administrator password."
  type        = "string"
  default     = ""
}

variable "windows_run_once_command_list" {
  description = "Commands that will be executed during OS customization phase."
  type        = "list"
  default     = []
}
