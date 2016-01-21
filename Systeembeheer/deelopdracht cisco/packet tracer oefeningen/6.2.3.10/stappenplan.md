# Lab - Configuring Multiarea OSPFv3 #


## Required resources ##
* 3 Routers (Cisco 1941 with Cisco IOS Release 15.2(4)M3 universal image or comparable)
* Console cables to configure the Cisco IOS devices via the console ports
* Serial cables as shown in the topology

## Part 1: Build the Network and Load Device Configurations ##

######Step 1

Additional info for Cisco Packet Tracer: The 1941 routers don't come with default serial ports. These modules have to be added by clicking on the router and, in the `physical`-pane, turn the router off and adding the `HWIC-2T` module.

For the serial connections you have to make sure that the DCE part of the cable is plugged into the right device(see ip addressing table).

#######Step 2

All commands required are available in the assignment.

## Part 2: 

######Step 1c

- **R1**: s0/0/0 administratively down -> no sh
- lo1 not in area 1 -> ipv6 ospf 1 area 1
- lo1: ipv6 address is wrong:  no ipv6 address 2001:DB80:ACAD:1::1/64, ipv6 address 2001:DB8:ACAD:1::1/64
- lo1: no link-local: ipv6 address fe80::1 link-local
- lo1: no area: ipv6 ospf 1 area 1
- lo2: no link-local: ipv6 address fe80::1 link-local
- s0/0/0:  ip address is wrong: no ip address 192.168.21.1 255.255.255.252, ip address 192.168.12.1 255.255.255.252
- **R2**: s0/0/1 down -> no sh won't solve it, problem on other side
- lo6 not in area 3 -> ipv6 ospf 1 area 3
- lo6 ipv6 address is wrong: no ipv6 address 2001:DB8:CAD:6::1/64, ipv6 address 2001:DB8:      ACAD:6::1/64
- lo6: no link-local: ipv6 address fe80::2 link-local
- lo6: not point to point: ipv6 ospf network point-to-point 
- **R3**: s0/0/1 administratively down -> no sh
- int lo5 wrong ip address: no ipv6 address 2001:DB8:ACAD:23::1/64, ipv6 address 2001:db8:acad:5::1/64
- int lo4: no link-local: ipv6 address FE80::3 link-local
- lo4: not point to point: ipv6 ospf network point-to-point
- lo5: not point to point: ipv6 ospf network point-to-point  
- int s0/0/1: no ip address assigned: ip address 192.168.23.1 255.255.255.252 
- int s0/0/1: no ipv6 address assigned: ipv6 address 2001:DB8:ACAD:23::1/64
- int s0/0/1: no link local address: ipv6 address FE80::3 link-local
- s0/0/1: no area: ipv6 ospf 1 area 3

## Part 3: Troubleshoot OSPFv2 ##

######Step 1

* On R1 the interfaces of R3 can't be pinged
* On R2 only lo4 and 5 from R3 can't be pinged
* On R3 only the directly connected interface on s2 can be pinged

######Step 2

* router ospf 1
* network 192.168.1.0 0.0.0.255 area 1
* exit
* ip route 0.0.0.0 0.0.0.0 lo0

######Step 4
* router ospf 1
* network 192.168.23.0 0.0.0.3 area 3




