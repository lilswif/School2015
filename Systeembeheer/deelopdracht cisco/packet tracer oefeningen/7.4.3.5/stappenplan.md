# Lab – Configuring Basic EIGRP for IPv4 #

## Required resources ##
* 3 Routers (Cisco 1941 with Cisco IOS Release 15.2(4)M3 universal image or comparable)
* 3 PCs (Windows 7, Vista, or XP with terminal emulation program, such as Tera Term)
* Console cables to configure the Cisco IOS devices via the console ports
* Ethernet and serial cables as shown in the topology

## Part 1: Build the Network and Verify Connectivity ##

######Step 1

While cabling, keep in mind that the connections between the routers and end devices require a copper cross-over cable. 

######Step 4

The first few steps are the same in every router.

1. en
2. conf t
3. no ip domain-lookup
4. hostname R1
5. enable secret class
6. line con 0
7. password cisco
8. login
9. logging synchronous
10. line vty 0 4
11. password cisco
12. login
13. exit
14. banner motd "Unauthorized access is prohibited"
15. end
16. copy running-config startup-config

configuring the ip addresses (in this example we'll use R1):

1. R1(config)#ipv6 unicast-routing 
2. ipv6 address 2001:db8:acad:a::1/64
3. ipv6 address fe80::1 link-local 
4. no sh
5. int s0/0/0
6. ipv6 address 2001:db8:acad:12::1/64
7. ipv6 address fe80::1 link-local 
8. no sh
9. int s0/0/1
10. ipv6 address 2001:db8:acad:13::1/64
11. ipv6 address fe80::1 link-local 
12. no sh




