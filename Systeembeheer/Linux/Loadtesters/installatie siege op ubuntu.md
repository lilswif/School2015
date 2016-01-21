# Installation & Usage of siege on Xubuntu

## Installation
Open a Bash shell (Git Bash on Windows), go to a suitable directory to store this project and issue the following commands:

```ShellSession
$ sudo apt-get update && sudo apt-get upgrade --show-upgraded
$ wget  http://download.joedog.org/siege/siege-3.1.0.tar.gz
$ tar -zxvf siege-VERSIENUMMERINVULLEN.tar.gz
$ cd siege-*/
$ sudo apt-get install build-essential
$ ./configure
$ make
$ sudo make install
```

## Make config file:
```
 - siege.config
```

## Define wich sites/pages to besiege
In this example we besiege multiple pages of the wordpress site from our stack.

1: Open the urls.txt  file located at /usr/local/etc/urls.txt. Add domain names, pages or IPs addresses to that file.
2: Paste next url's below the comment section

```
192.168.56.77/wordpress/
192.168.56.77/wordpress/index.php/2015/09/21/demo-post-48/
http://192.168.56.77/wordpress/index.php/category/uncategorized/
```
## Configure test scenario 
in your home folder:

```
$ nano .siegerc
```

## START THE ATTACK: SIEGE !!!

```
$siege
```