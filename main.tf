
/**
* Usage Example 
*
* variable "datacenter" {
* }
* 
* variable "cluster" {
* }
* 
* variable "datastore" {
* }
* 
* provider "vsphere" {
* 
* }
* 
* provider "vsphere" {
*   version = "~> 1.11"
* }
* 
* module "custom" {
*   source = "source"
* 
*   datacenter = "${var.datacenter}"
*   cluster    = "${var.cluster}"
*   datastore  = "${var.datastore}"
* 
*   virtual_machine_name_prefix  = "bare"
*   virtual_machine_network_vlan = "VM Network"
* 
*   virtual_machine_guest_id  = "windows64"
*   virtual_machine_scsi_type = "lsilogic-sas"
* }
* 
* module "webservers" {
*   source = "source"
* 
*   datacenter = "${var.datacenter}"
*   cluster    = "${var.cluster}"
*   datastore  = "${var.datastore}"
* 
*   folder = "Frontend"
* 
*   virtual_machine_instance_count     = 2
*   virtual_machine_template_os_family = "windows"
*   virtual_machine_template           = "win-2016-template"
*   virtual_machine_name_prefix        = "web"
* 
*   virtual_machine_network_vlan = "VM Network"
* 
*   virtual_machine_network_address  = "192.168.0.0/24"
*   virtual_machine_ip_address_start = 100
*   virtual_machine_gateway          = "192.168.0.1"
*   virtual_machine_dns_servers      = ["8.8.8.8", "1.1.1.1"]
* }
* 
* module "rancher" {
*   source = "source"
* 
*   datacenter = "${var.datacenter}"
*   cluster    = "${var.cluster}"
*   datastore  = "${var.datastore}"
* 
*   folder = "Rancher"
* 
*   virtual_machine_instance_count     = 2
*   virtual_machine_template_os_family = "linux"
*   virtual_machine_template           = "rancher-os-template"
*   virtual_machine_name_prefix        = "rancher"
* 
*   virtual_machine_network_vlan = "VM Network"
* 
*   virtual_machine_network_address  = "192.168.0.0/24"
*   virtual_machine_ip_address_start = 150
*   virtual_machine_gateway          = "192.168.0.1"
*   virtual_machine_dns_servers      = ["8.8.8.8", "1.1.1.1"]
* }
* 
*/

