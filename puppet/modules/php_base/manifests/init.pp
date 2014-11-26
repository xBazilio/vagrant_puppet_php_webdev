# install base php5 packages with one command.
# It is necessary for not insalling apache as requirement for php5 package
class php_base {
    exec {
        'php5 base':
        command => '/usr/bin/apt-get -q -y -o Dpkg::Options::="--force-confdef" -o DPkg::Options::="--force-confold" install php5 php5-cli php5-fpm';
    }
}
