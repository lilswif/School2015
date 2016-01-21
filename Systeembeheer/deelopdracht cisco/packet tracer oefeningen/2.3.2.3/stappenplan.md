#Lab 2.3.2.3: Configuring Rapid PVST+, PortFast, and BPDU Guard

###Required Resources
1. 3 Switches (Cisco 2960 with Cisco IOS Release 15.0(2) lanbasek9 image or comparable)
2. 2 PCs (Windows 7, Vista, or XP with terminal emulation program, such as Tera Term)
3. Console cables to configure the Cisco IOS devices via the console ports
4. Ethernet cables as shown in the topology

###Part 1: Build the Network and Configure Basic Device Settings

Step 1 through 3 require no detailed instructions.

#####Step 4

Basic settings for switches, switch 1 is used in these commands

1. en
2. conf t
3. no ip domain-lookup
4. hostname S1
5. line con 0
6. password cisco
7. login
8. line vty 0 4
9. password cisco 
10. login
11. exit
12. enable secret class
13. line con 0
14. logging synchronous
15. exit
16. int range fa0/1-24
17. shutdown
18. exit
19. int range g0/1-2
20. shutdown
21. end
22. copy running-config startup-config

######notes
* To test whether all interfaces are down, go to the user EXEC mode and use `show ip int br`
* Repeat these steps for switch 2 and 3. Keep in mind that step 4, changing the hostname, requires you to change `S1` to the appropriate hostname. 
* In steps 13 and 14 we only enable synchronous logging on the console line. If you'ld like to prevent console messages from interrupting command entry on other lines, simply add the `logging synchronous` to those lines.

###Part 2: Configure VLANs, Native VLAN, and Trunks

######Step 1

See the assignment for instructions on how to create the VLANs on the switches.

Use the `show vlan` command in privileged EXEC mode to check whether the vlans were created with the appropriate name.

######Step 2

For switch 1:

1. In global configuration mode: `int fa0/6`
2. `switchport mode access`
3. `switchport access vlan 10`
4. `no sh`

For switch 3: 

1. In global configuration mode: `int fa0/18`
2. `switchport mode access`
3. `switchport access vlan 10`
4. `no sh` 

######Step 3

Use the following commands on all 3 switches on fa0/1 and fa0/3

1. switchport mode trunk
2. switchport trunk native vlan 99
3. no sh

######Step 4

Using the Addressing Table, configure the management interface on all switches with the appropriate IP address.

###Part 3: Configure the Root Bridge and Examine PVST+ Convergence

######Step 2

* Switch 2 has to become the primary root for the STP: `spanning-tree vlan 1,10,99 root primary`
* Similarly, switch 1 has to become the secondary root for the STP: `spanning-tree vlan 1,10,99 root secondary`

######Step 3

You may run into some problems when trying to do these steps in Cisco Packet Tracer. Specifically part b seems impossible to be done. You aren't able to debug the spanning-tree events.
