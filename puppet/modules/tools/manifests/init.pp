class tools {
    package {
        ['git', 'curl', ntp]:
        ensure => present;

        ['mlocate']:
        ensure => purged;
    }

    exec { 'composer_install':
        command => 'curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer',
        path    => '/usr/bin:/usr/sbin:/bin',
        require => Package['curl'],
    }
}
