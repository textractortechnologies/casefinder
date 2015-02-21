Vagrant.configure(2) do |config|
  config.vm.provider "virtualbox" do |vb|
    #We don't wish to rely on virtualbox DNS intermediaries.
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "off"]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "off"]
    #2 GB and 4 CPU may or may not be conservative but helps on multicore builds
    vb.customize ["modifyvm", :id, "--memory", "2048"]
    vb.customize ["modifyvm", :id, "--cpus", "4"]
    vb.gui = false
  end
  config.vm.box = "puppetlabs/centos-7.0-64-puppet"

  config.vm.provision "puppet" do |puppet|
    puppet.options = "--verbose --debug"
    puppet.working_directory = '/tmp'
    puppet.manifests_path = "manifests"
    puppet.module_path    = "modules"
    puppet.manifest_file  = "site.pp"
    ## custom facts provided to Puppet
    puppet.facter = {
      ## tells default.pp that we're running in Vagrant
      "is_vagrant" => true,
    }
  end

  config.vm.define "casefinder" do |box|
    box.vm.hostname = "casefinder.local"
    box.vm.network "private_network", ip: "192.168.20.3"
  end

end
