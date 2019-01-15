Vagrant.configure("2") do |config|
  config.vm.box = "opentable/win-2012r2-standard-amd64-nocm"
  config.vm.hostname = "host-win"
  winClientIP = "192.168.99.103"
  config.vm.network "private_network", ip: winClientIP

  config.vm.provider "virtualbox" do |vb|
    vb.gui = false

    #
    # Quoting: http://www.virtualbox.org/manual/ch03.html#settings-processor
    #
    #     Enabling the I/O APIC is required for 64-bit guest operating
    #     systems, especially Windows Vista; it is also required if you
    #     want to use more than one virtual CPU in a virtual machine.
    #
    vb.customize ["modifyvm", :id, "--ioapic", "on"]

    #
    # The conversion utility appears to use a lot of CPU, so lets give
    # it some more resources to work with.
    #
    vb.memory = "2048"
    vb.cpus = "2"
  end

  config.vm.provision(
    "bootstrap",
    type: "shell",
    run: "never",
    path: "scripts/bootstrap.ps1"
  )
  config.vm.provision(
    "shell",
    run: "always",
    privileged: true,
    powershell_elevated_interactive: true,
    path: "scripts/nbrplay.ps1"
  )
end
