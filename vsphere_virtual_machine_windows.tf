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
      network_interface = {}
      windows_options {
        computer_name               = "${upper(format("%s-%d", var.virtual_machine_name_prefix, count.index))}"
        admin_password              = "${var.windows_administrator_password}"
        run_once_command_list       = "${var.windows_run_once_command_list}"
        auto_logon       = true
        auto_logon_count = 1

        # Run these commands after autologon. Configure WinRM access and disable windows firewall.
        run_once_command_list = [
Write-Host "Delete any existing WinRM listeners",
winrm delete winrm/config/listener?Address=*+Transport=HTTP  2>$Null,
winrm delete winrm/config/listener?Address=*+Transport=HTTPS 2>$Null,

Write-Host "Create a new WinRM listener and configure",
winrm create winrm/config/listener?Address=*+Transport=HTTPS,
winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="0"}',
winrm set winrm/config '@{MaxTimeoutms="7200000"}',
winrm set winrm/config/service '@{AllowUnencrypted="true"}',
winrm set winrm/config/service '@{MaxConcurrentOperationsPerUser="12000"}',
winrm set winrm/config/service/auth '@{Basic="true"}',
winrm set winrm/config/client/auth '@{Basic="true"}',

Write-Host "Configure UAC to allow privilege elevation in remote shells",
$Key = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System',
$Setting = 'LocalAccountTokenFilterPolicy',
Set-ItemProperty -Path $Key -Name $Setting -Value 1 -Force,

Write-Host "turn off PowerShell execution policy restrictions",
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine,
New-Item                                                                       `
    -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Network\NewNetworkWindowOff" `
    -Force,

Set-NetConnectionProfile                                                       `
    -InterfaceIndex (Get-NetConnectionProfile).InterfaceIndex                  `
    -NetworkCategory Private,

Set-Item WSMan:\localhost\Service\AllowUnencrypted -Value True,
Set-Item WSMan:\localhost\Service\Auth\Basic       -Value True,
Write-Host "Configure and restart the WinRM Service; Enable the required firewall exception",
Stop-Service -Name WinRM,
Set-Service -Name WinRM -StartupType Automatic,
netsh advfirewall firewall set rule name="Windows Remote Management (HTTP-In)" new action=allow localip=any remoteip=any,
Start-Service -Name WinRM,

$profiles = Get-NetConnectionProfile,
Foreach ($i in $profiles) {
    Write-Host ("Updating Interface ID {0} to be Private.." -f $profiles.InterfaceIndex)
    Set-NetConnectionProfile -InterfaceIndex $profiles.InterfaceIndex -NetworkCategory Private
},

Write-Host "Obtaining the Thumbprint of the Certificate from KeyVault",
$Thumbprint = (Get-ChildItem -Path Cert:\LocalMachine\My | Where-Object {$_.Subject -match "$ComputerName"}).Thumbprint,

Write-Host "Enable HTTPS in WinRM..",
winrm create winrm/config/Listener?Address=*+Transport=HTTPS "@{Hostname=`"$ComputerName`"; CertificateThumbprint=`"$Thumbprint`"}",

Write-Host "Enabling Basic Authentication..",
winrm set winrm/config/service/Auth "@{Basic=`"true`"}",

Write-Host "Re-starting the WinRM Service",
net stop winrm,
net start winrm,

Write-Host "Open Firewall Ports",
netsh advfirewall firewall add rule name="Windows Remote Management (HTTPS-In)" dir=in action=allow protocol=TCP localport=5986
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
