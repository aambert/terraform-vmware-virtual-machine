data "vsphere_datacenter" "dc" {
  name = "${var.datacenter}"
}

data "vsphere_compute_cluster" "cluster" {
  name          = "${var.cluster}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_resource_pool" "resource_pool" {
  name          = "${var.resource_pool}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_datastore" "datastore" {
  name          = "${var.datastore}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  name          = "${var.virtual_machine_template}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "vlan" {
  name          = "${var.virtual_machine_network_vlan}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}
