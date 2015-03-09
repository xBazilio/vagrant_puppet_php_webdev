# create a new run stage to ensure certain modules are included first
stage { 'pre':
    before => Stage['main']
}

# create other stages for ordering
stage {'php_base':}
stage {'php_modules':}
stage {'tools':}

Stage['main']->Stage['php_base']->Stage['php_modules']->Stage['tools']

# add the baseconfig module to the new 'pre' run stage
class { 'baseconfig':
    stage => 'pre'
}

# add other modules to their stages
class { 'php_base':
    stage => 'php_base'
}
class { 'php_modules':
    stage => 'php_modules'
}
class { 'tools':
    stage => 'tools'
}

# set defaults for file ownership/permissions
File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
}

include baseconfig, php_base, php_modules, mysql, nginx, nginx_vhosts, tools
