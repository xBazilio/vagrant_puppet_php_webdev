class nginx_vhosts {
    # copy all vhost files to /etc/nginx/sites-available
    file { '/etc/nginx/sites-available':
        recurse => true,
        purge => true,
        source => 'puppet:///modules/nginx_vhosts/vhosts',
        require => Package['nginx'];
    }

    exec {
        # remove old vhost links
        'rm nginx vhosts links':
        before => Exec['link nginx vhosts'],
        command => '/bin/rm -fR /etc/nginx/sites-enabled/*';

        # relink all vhost files to /etc/nginx/sites-enabled/
        'link nginx vhosts':
        command => '/bin/ln -s /etc/nginx/sites-available/* /etc/nginx/sites-enabled/',
        require => File['/etc/nginx/sites-available'],
        notify => Service['nginx'];
    }
}
