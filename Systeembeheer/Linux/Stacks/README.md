# Virtual Environments for load testing

## Dependencies

In order to set up this environment, you need:

* [Git](https://git-scm.com/downloads) (including Git Bash)
* [VirtualBox, including the "Extension pack"](https://www.virtualbox.org/wiki/Downloads/)
* [Vagrant](https://www.vagrantup.com/downloads.html)
* [Ansible](http://docs.ansible.com/intro_installation.html) (on [supported platforms](http://docs.ansible.com/intro_installation.html#control-machine-requirements))

## Getting started

Open a Bash shell (Git Bash on Windows), go to a suitable directory to store this project and issue the following commands:

```ShellSession
$ git clone --config core.autocrlf=false https://github.com/HoGentTIN/ops3-g05.git
$ cd ops3-g05/linux/Stacks
$ sudo bash scripts/dependencies.sh
$ vagrant up
```

This creates the following machines:
```
 - 192.168.56.77/wordpress => Wordpress-server with tons of random posts
 - 192.168.56.87/collectd/ => Collectd graphs of the wordpress server
```


