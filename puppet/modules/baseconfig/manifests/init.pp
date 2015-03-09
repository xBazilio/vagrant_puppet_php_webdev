# == Class: baseconfig
#
# Performs initial configuration tasks for all Vagrant boxes.
#
class baseconfig {
    exec {
        'GnuPG key':
        before => Exec['update sources'],
        command => '/usr/bin/wget http://www.dotdeb.org/dotdeb.gpg -O - | /usr/bin/apt-key add -';

        'update sources':
        before => Exec['dist-upgrade'],
        command => '/usr/bin/apt-get update';

        'dist-upgrade':
        command => '/usr/bin/apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade';

        'reconfigure timezone':
        command => '/usr/sbin/dpkg-reconfigure -f noninteractive tzdata';
    }

    host { 'hostmachine':
        ip => $hostip;
    }

    file {
        '/etc/timezone':
        before => Exec['reconfigure timezone'],
        source => 'puppet:///modules/baseconfig/timezone';

        '/home/vagrant/.bashrc':
        owner => 'vagrant',
        group => 'vagrant',
        source => 'puppet:///modules/baseconfig/bashrc-vagrant';

        '/root/.bashrc':
        source => 'puppet:///modules/baseconfig/bashrc-root';

        '/etc/bash.bashrc':
        source => 'puppet:///modules/baseconfig/bash.bashrc';

        '/etc/apt/sources.list':
        before => Exec['update sources'],
        source => 'puppet:///modules/baseconfig/sources.list';

        '/home/vagrant/www':
        ensure => directory,
        owner => 'vagrant',
        group => 'vagrant',
        mode => '0775',
        before => Mount['/home/vagrant/www'];
    }

    mount { '/home/vagrant/www':
        require => Host['hostmachine'],
        ensure => mounted,
        device => 'hostmachine:/www',
        fstype => 'nfs',
        options => 'auto',
        dump => '0',
        pass => '0';
    }
}
