#Lab 6.2.3.8: Configuring Multiarea OSPFv2

###Required Resources
1. 3 Routers (Cisco 1941 with Cisco IOS Release 15.2(4)M3 universal image or comparable)
2.  Console cables to configure the Cisco IOS devices via the console ports 
3.  Serial cables as shown in the topology


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

Now we have to configure the ip addresses of the serial ports and the loopback addresses.
In this example we'll use router 1, although these commands are mostly the same for the other devices.
S0/0/0 is the DCE side of the serial connection so we also have to change the clock rate. In the other routers, if those ports aren't the DCE side, simply ignore the clock rate command.

1. r1(config)#: int lo0
2. ip address 209.165.200.225 255.255.255.252
3. int lo1 
4. ip address 192.168.1.1 255.255.255.0
5. int lo2
6. ip address 192.168.2.1 255.255.255.0
7. int s0/0/0
8. ip address 192.168.12.1 255.255.255.0
9. no sh
10. bandwidth 128
11. clock rate 128000
12. end
13. copy running-config startup-config 

## Part 2: Configure a Multiarea OSPFv2 Network ##

######Step 2

After adding the networks you have to set the loopback networks to passive.


For R1 this is:

1. R1(config-router)#passive-interface lo2
2. R1(config-router)#passive-interface lo1

lo0 as default route:

1. R1(config)#ip route 0.0.0.0 0.0.0.0 lo0

Configure OSPF to propagate:

1. R1(config-router)#default-information originate 

######Step 3

1. R2(config)#: router ospf 1
2. router-id 2.2.2.2
3. R2(config-router)#network 192.168.6.0 0.0.0.255 area 3
4. R2(config-router)#network 192.168.12.0 0.0.0.3 area 0
5. R2(config-router)#network 192.168.23.0 0.0.0.3 area 3
6. passive-interface lo6

######Step 4

1. R2(config)#: router ospf 1
2. router-id 3.3.3.3
3. R3(config-router)#network 192.168.4.0 0.0.0.255 area 3
4. R3(config-router)#network 192.168.5.0 0.0.0.255 area 3
5. R3(config-router)#network 192.168.23.0 0.0.0.3 area 3
6. passive-interface lo4
7. passive-interface lo5

######Step 6

For router 1:

1. for s0/0/0: `R1(config-if)#ip ospf message-digest-key 1 md5 Cisco123`
2. R1(config-if)#ip ospf authentication message-digest  

Repeat for the other 2 routers.

## Part 3: Configure Interarea Summary Routes ##

######Step 2

Due to the lack of space the answer to questions 2b will be written down here:

R2:

                Summary Net Link States (Area 0)
| Link ID   |       ADV Router   |   Age      |   Seq#    |   Checksum|
|---|---|---|---|---|
|192.168.6.1 |    2.2.2.2    |     574    |   0x80000005 |0x005190|
|192.168.23.0  |  2.2.2.2        | 559       |  0x80000008 |0x001ba7|
|192.168.1.1    | 1.1.1.1       |  1423       | 0x80000003 |0x00aa42|
|192.168.2.1    | 1.1.1.1       |  1423       | 0x80000004 |0x009d4d|
|192.168.4.1    | 2.2.2.2       |  566        | 0x80000006 |0x0003cf|
|192.168.5.1    | 2.2.2.2      |   566        | 0x80000007| 0x00f5da|


                Summary Net Link States (Area 3)
|Link ID |        ADV Router |     Age   |      Seq#     |  Checksum|
|---|---|---|---|---|
|192.168.12.0 |   2.2.2.2     |    573    |     0x80000008| 0x009439|
|192.168.1.1   |  2.2.2.2     |    650    |     0x80000006| 0x0024b1|
|192.168.2.1   |  2.2.2.2     |    650    |     0x80000007| 0x0017bc|

R3: 

                Summary Net Link States (Area 3)
|Link ID |        ADV Router |     Age     |    Seq#      | Checksum|
|---|---|---|---|---|
|192.168.12.0 |   2.2.2.2     |    2781     |   0x80000001 |0x00a232|
|192.168.1.1   |  2.2.2.2     |    1057     |   0x80000006 |0x0024b1|
|192.168.2.1   |  2.2.2.2     |    1057     |   0x80000007 |0x0017bc|

######Step 3

Summary route for area 3(only on border routers):
192.168.4.0/222


