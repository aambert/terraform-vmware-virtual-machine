resource "vsphere_virtual_machine" "bare" {
  count = "${var.virtual_machine_template_os_family == "" ? var.virtual_machine_instance_count : 0}"

  name             = "${format("%s-%d", var.virtual_machine_name_prefix, count.index)}"
  resource_pool_id = "${var.resource_pool != "" ? data.vsphere_resource_pool.resource_pool.id : data.vsphere_compute_cluster.cluster.resource_pool_id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  annotation = "Managed by Terraform"

  folder = "${var.folder}"

  num_cpus = "${var.virtual_machine_num_cpus}"
  memory   = "${var.virtual_machine_memory * 1024}"

  guest_id  = "${var.virtual_machine_guest_id}"
  scsi_type = "${var.virtual_machine_scsi_type}"

  network_interface {
    network_id = "${data.vsphere_network.vlan.id}"
  }

  disk {
    label            = "disk0"
    size             = "${var.virtual_machine_disk_size}"
    thin_provisioned = true
  }

  tags = "${var.virtual_machine_tags}"

}
