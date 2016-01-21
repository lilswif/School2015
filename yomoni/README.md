# YOMoni
by Jens De Vreese, Frederik Van Brussel

## Dependencies

In order to set up this environment, you need:

* [Git](https://git-scm.com/downloads) (including Git Bash)
* [VirtualBox, including the "Extension pack"](https://www.virtualbox.org/wiki/Downloads/)
* [Vagrant](https://www.vagrantup.com/downloads.html)
* [Ansible](http://docs.ansible.com/intro_installation.html) (on [supported platforms](http://docs.ansible.com/intro_installation.html#control-machine-requirements))

## Getting started

Open a Bash shell (Git Bash on Windows), go to a suitable directory to store this project and issue the following commands:

```ShellSession
$ git clone --config core.autocrlf=false https://github.com/lilswif/yomoni.git
$ cd yomoni
```

in the file ```ansible/host_vars/yomoni.yml``` you can use the ansible variable ```siege_targets```
to add sites wich siege will attack.

eg.
``` 
siege_targets:
  - 192.168.56.77/wordpress 
  - www.atestwebsite.co
```

> note: This can always be altered in the guest by the command ```sudo vi /usr/local/etc/urls.txt```

now its time to launch our virtual machine through the commandline:

```Shellsession
$vagrant up
```

Next, ssh in our machine with 

```
$vagrant ssh
```

## Configure Siege Strategy and Lauch the Attacks

!!! Always run the following commands run from the ```/home/vagrant/yomoni``` folder !!!

To configure the siege strategy, launch following command:
```
$sudo vi config.cfg
```

Following variables can be changed:

| Variable  | value(s) | required |  explanation |
| :---     	|    ---:  |     ---: |    ---:      |
| RANGE |  TRUE / FALSE | yes  |  if true, Siege will test all numbers of users between a interval, including the start en stop value |
| START |  number       | if RANGE = TRUE | Start value of concurring users |
| STOP  |  number       | if RANGE = TRUE | After wich Concurring users Siege wil stop the engage |
| JUMP  |  number       | if RANGE = TRUE | Interval incrementation |
| CONCUSERS | number(s) | if RANGE = FALSE | Give the concurring users siege will test, divided by a space |
| NUMBEROFTESTS | number | yes | how much each concurring user will be tested |
| TIME | number + S/D/M | yes | how long a individual test will take |
| DELAY | number | yes | siege delay value |

After saving, all u have to do is run the following command:

```
sudo ./runsiege.sh
```

The shell will ask u for a name of the html page, and if all variables are okay.
After hitting ```y```, its time to grab a coffee and wait till all tests are finished.

## Upon completion
on the hostmachine, go to your favorite browser and visit 
```
192.168.56.120
```
In the menu will be a page with all the results of the test.

## Credits 

[ bertvv ](www.github.com/bertvv) for the [ http-service ](https://github.com/bertvv/ansible-role-httpd), [el7](https://github.com/bertvv/ansible-role-el7) configuration and [ansible skeleton](https://github.com/bertvv/ansible-skeleton). </br>
[ Highcharts ](www.highcharts.com) for generating beautiful graphs </br>
[ Joe Bulldog ]( https://joedog.org/ ) for the siege loadmonitor. </br>


