# Lab - Configuring Multiarea OSPFv3 #


## Required resources ##
* 3 Routers (Cisco 1941 with Cisco IOS Release 15.2(4)M3 universal image or comparable)
* 3 PCs (Windows 7, Vista, or XP with terminal emulation program, such as Tera Term)
* Console cables to configure the Cisco IOS devices via the console ports
* Serial cables as shown in the topology

## Part 1: Build the Network and Configure Basic Device Settings ##

######Step 1

Additional info for Cisco Packet Tracer: The 1941 routers don't come with default serial ports. These modules have to be added by clicking on the router and, in the `physical`-pane, turn the router off and adding the `HWIC-2T` module.

For the serial connections you have to make sure that the DCE part of the cable is plugged into the right device(see ip addressing table).

#######Step 3

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
15. service password-encryption

Now we have to configure the ip addresses of the serial ports and the loopback addresses.
In this example we'll use router 1, although these commands are mostly the same for the other devices.

1. R1(config)#: ipv6 unicast-routing
2. int s0/0/0
3. ipv6 address 2001:db8:acad:12::1/64 
4. ipv6 address fe80::1 link-local 
5. no sh
5. int lo0
6. ipv6 address 2001:db8:acad::1/64 
7. int lo1
8. ipv6 address 2001:db8:acad:1::1/64
9. int lo2
10. ipv6 address 2001:db8:acad:2::1/64
11. int lo3
12. ipv6 address 2001:db8:acad:3::1/64  
13. end
14. copy running-config startup-config 

##Part 3: Configure Interarea Route Summarization ##

######Step 3

Summary address: `2001:db8:acad:4::/62`

Manually configure: 

1. ipv6 router ospf 1
2. area 2 range 2001:db8:acad:4::/62







