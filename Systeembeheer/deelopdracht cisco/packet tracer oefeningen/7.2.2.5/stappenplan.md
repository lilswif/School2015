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

1. R1(config)#int g0/0
2. R1(config-if)#ip address 192.168.1.1 255.255.255.0
3. R1(config-if)#no sh
4. R1(config-if)#int s0/0/0
5. R1(config-if)#ip address 10.1.1.1 255.255.255.252
6. R1(config-if)#no sh
7. R1(config-if)#int s0/0/1
8. R1(config-if)#ip address 10.3.3.1 255.255.255.252
9. R1(config-if)#no sh

## Part 2: Configure EIGRP Routing ##

######Step 3

**R2:**

1. router eigrp 10
2. network 192.168.2.0 0.0.0.255
3. network 10.1.1.0 0.0.0.3
4. network 10.2.2.0 0.0.0.3

**R3:**

1. router eigrp 10
2. network 192.168.3.0 0.0.0.255
3. network 10.3.3.0 0.0.0.3
4. network 10.2.2.0 0.0.0.3

