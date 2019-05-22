resource "vsphere_virtual_machine" "windows" {
  count = "${var.virtual_machine_template_os_family == "windows" ? var.virtual_machine_instance_count : 0}"

  name             = "${format("%s-%d", var.virtual_machine_name_prefix, count.index)}"
  resource_pool_id = "${var.resource_pool != "" ? data.vsphere_resource_pool.resource_pool.id : data.vsphere_compute_cluster.cluster.resource_pool_id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  annotation = "Managed by Terraform"

  folder = "${var.folder}"

  num_cpus = "${var.virtual_machine_num_cpus}"
  memory   = "${var.virtual_machine_memory * 1024}"

  guest_id  = "${data.vsphere_virtual_machine.template.guest_id}"
  scsi_type = "${data.vsphere_virtual_machine.template.scsi_type}"

  network_interface {
    network_id   = "${data.vsphere_network.vlan.id}"
    adapter_type = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"
  }

  disk {
    label            = "disk0"
    size             = "${data.vsphere_virtual_machine.template.disks.0.size}"
    eagerly_scrub    = "${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
  }

  tags = "${var.virtual_machine_tags}"

  clone {

    template_uuid = "${data.vsphere_virtual_machine.template.id}"
    linked_clone  = "${var.virtual_machine_linked_clone}"

    customize {
      windows_options {
        computer_name         = "${upper(format("%s-%d", var.virtual_machine_name_prefix, count.index))}"
        admin_password        = "${var.windows_administrator_password}"
        run_once_command_list = "${var.windows_run_once_command_list}"
      }

      network_interface {
        ipv4_address    = "${var.virtual_machine_network_address != "" ? cidrhost(var.virtual_machine_network_address, var.virtual_machine_ip_address_start + count.index) : ""}"
        ipv4_netmask    = "${var.virtual_machine_network_address != "" ? element(split("/", var.virtual_machine_network_address), 1) : 0}"
        dns_server_list = "${var.virtual_machine_dns_servers}"
      }

      ipv4_gateway = "${var.virtual_machine_gateway}"

    }
  }
}
