class dev_tools {
    package {
        ['git', 'curl']:
        ensure => present;
    }

    exec { 'composer_install':
        command => 'curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer',
        path    => '/usr/bin:/usr/sbin',
        require => Package['curl'],
    }
}
