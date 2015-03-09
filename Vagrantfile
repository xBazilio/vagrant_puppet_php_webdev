# You can adjust these variables to suit your needs
box      = 'puppetlabs/debian-7.8-64-puppet'
hostname = 'webdev'
ip       = '192.168.50.10'
hostip   = '192.168.50.1'
cpus     = 2
memory   = 3072

Vagrant.configure('2') do |config|
    config.vm.box = box
    config.vm.hostname = hostname
    config.vm.network 'private_network', ip: ip

    # Adjust box parameters using settings variables above
    config.vm.provider 'virtualbox' do |v|
        v.name = hostname
        v.memory = memory
        v.cpus = cpus
    end

    # Enable puppet apply provisioner
    config.vm.provision 'puppet' do |puppet|
        puppet.manifests_path = 'puppet/manifests'
        puppet.manifest_file  = 'default.pp'
        puppet.module_path = 'puppet/modules'
        puppet.facter = {
            'hostip' => hostip
        }
    end

    # disable default vagrant share. NFS4 will be used.
    config.vm.synced_folder '.', '/vagrant', disabled: true

end
