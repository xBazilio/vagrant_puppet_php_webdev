class mysql {
    package { ['mysql-server', 'mysql-client']:
        ensure => present;
    }

    service { 'mysql':
        ensure  => running,
        require => Package['mysql-server'];
    }

    file { '/etc/mysql/my.cnf':
        source  => 'puppet:///modules/mysql/my.cnf',
        require => Package['mysql-server'],
        notify  => Service['mysql'];
    }

    exec { 'set-mysql-password':
        unless  => 'mysqladmin -uroot -proot status',
        command => "mysqladmin -uroot password root",
        path    => ['/bin', '/usr/bin'],
        require => Service['mysql'];
    }
}
