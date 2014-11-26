class php_modules {
    package { [
        'php5-curl',
        'php5-dev',
        'php5-gd',
        'php5-imagick',
        'php5-intl',
        'php5-mcrypt',

        'php5-memcache',
        'memcached',

        'php5-mysql',
        'php5-sqlite',
        'php5-xdebug']:
        ensure => present,
        notify => Service['php5-fpm'];
    }

    service { 'memcached':
        ensure  => running,
        require => Package['memcached'];
    }

    service { 'php5-fpm':
        ensure  => running;
    }

    file {
        '/etc/php5/cli/php.ini':
        source => 'puppet:///modules/php_modules/php-cli.ini';

        '/etc/php5/fpm/php.ini':
        source => 'puppet:///modules/php_modules/php-fpm.ini',
        notify => Service['php5-fpm'];

        '/etc/php5/fpm/pool.d/www.conf':
        source => 'puppet:///modules/php_modules/www.conf',
        notify  => Service['php5-fpm'];

        '/etc/php5/mods-available/xdebug.ini':
        source => 'puppet:///modules/php_modules/xdebug.ini',
        require => Package['php5-xdebug'],
        notify => Service['php5-fpm'];

        #do not use xdebug for cli, becouse of composer + xdebug segfaults
        '/etc/php5/cli/conf.d/20-xdebug.ini':
        ensure => absent,
        require => Package['php5-xdebug'];

        '/etc/memcached.conf':
        source => 'puppet:///modules/php_modules/memcached.conf',
        require => Package['memcached'],
        notify  => Service['memcached'];
    }
}
