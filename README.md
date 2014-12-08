Vargant and puppet PHP web development enviroment
=================================================

# About

The main goal is to simplify deploying of web development enviroment. Instead of installing web server, data base server and PHP interpreter into your host system, you can install all of it into virtual machine and run it when it is necessary to do some work.

The project could be usefull for web studios, when it is necessary to share the same development enviroment among developers of different levels and not to force them building it from scratch and making common mistakes.

All you need to start working is to execute:

    vagrant up

The configuration is based on [vagrant-examples](https://github.com/patrickdlee/vagrant-examples)

Everywhere you see USER - it's your system username.

# The idea

* The enviroment is in the virtual machine
* [Virtualbox](https://www.virtualbox.org/) and [Vagrant](https://www.vagrantup.com/) are used
* The enviroment is based on `Debian 7 x64` with preinstalled puppet
* [Puppet](http://puppetlabs.com/) is used for automatic installing and setting the software
* All settings are done with puppet and applied with `vagrant reload --provision`
* Web projects files are stored in the host system and available in the guest system through NFSv4 protocol

# Features

* Web projects are running on nginx + php-fpm + mysql technology
* You can create sites like *.loc without necessity to restart the web server
* All projects are located in `/home/USER/www`
* Letters sent with `mail()` are stored in .eml files in `/home/USER/www/EMAILS`
* For projects like \*.loc you have to create folder structure like `/home/USER/www/\*.loc/web/htdocs`, where htdocs folder is the DOCUMENT_ROOT
* You can create projects in the folder `/home/USER/www` with custom config. Create virtualhosts in the folder `/home/USER/www/puppet/modules/nginx_vhosts/files/vhosts` and run `vagrant reload --provision`

# Virtual machine info

* IP: `192.168.50.10`
* Password for system user root: `puppet`
* Password for Mysql user root: `root`

# Installing

Put files of this project in the folder `/home/USER/www`, where USER is your username. In this case file `Vagrantfile` will be available in the path `/home/USER/www/Vagrantfile`.

For installing vagrant go to https://www.vagrantup.com/downloads.html and follow the instructions.

## Setting up NFS

Built in the vagrant shared folder of type nfs is not suitable for it uses NFSv3. Using NFSv3 there are performance issues with file system. To avoid this you need to use protocol NFSv4.

To share projects folder through NFS you need to follow steps below, working on host system:

* Install NFS Kernel Server, if not installed

    ```sudo apt-get install nfs-kernel-server```

* Create export folder

    ```sudo mkdir -p /home/nfs/www```

* Copy string from file `fstab.txt` to file `/etc/fstab`. Replace USERNAME to your system username

* Mount projects folder

    ```sudo mount -a```

* Copy strings from file `exports.txt` to file `/etc/exports`. Restrict IP range, if it's necessary.

* Restart the NFS Kernel Server

    ```sudo service nfs-kernel-server restart```

## Install plugin for Vagrant

For virtual enviroment worked properly it is necessary to have actual Virtualbox GuestAdditions. There is the plugin for Vagrant, which automatically installs actual version of Virtualbox GuestAdditions.

To install the plugin run:

    vagrant plugin install vagrant-vbguest

## Run vagrant

Please be patient and run:

    vagrant up

Virtual system will be updated and software will be installed and set.

After the first run it is recommended to reload virtual machine for dist upgrade take effect:

    vagrant reload

Now you can quickly suspend the machine:

    vagrant suspend

And quickly resume it:

    vagrant up

# Using

I'll show it by example. Let's create **test.loc** project.

Create project folders and PHP file:

    mkdir -p /home/USER/www/test.loc/web/htdocs
    echo "<?php phpinfo();" > /home/USER/www/test.loc/web/htdocs/info.php

Put string to file `/etc/hosts`:

    192.168.50.10 test.loc

Your project available by URL http://test.loc

# Tips & tricks

## Bash completion

Save file [vagrant.bash-completion](https://github.com/camptocamp/vagrant-debian-package/blob/master/debian/vagrant.bash-completion) to `/etc/bash_completion.d/vagrant`

## Automatic suspend

When virtual machine is running you can't shutdown or reboot your host system without errors. It is possible to automatically save state of your machines upon reboot or shutdown. To achieve this put in file `/etc/default/virtualbox` folowing config:

    SHUTDOWN_USERS="USER"
    SHUTDOWN=savestate
