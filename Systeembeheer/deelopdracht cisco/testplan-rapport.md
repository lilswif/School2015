## Testplan en -rapport: Projecten 3 Systeembeheer, partim Cisco

* Verantwoordelijke uitvoering: `Kjeld Antjon`
* Verantwoordelijke testen: `Matthias Derudder`, `Frederik Van Brussel`, `Daan Van Hecke`

### Testplan

Per labo een testplan: 

**2.3.2.3: **

* All VLAN's should be properly modified: `show vlan br`
* Verify connection between PC's: ping in terminal
* Verify Spanning-tree configuration: `show spanning-tree`
 
**6.2.3.8:**

* Verify Layer 3 connectivity: `show ip int br` on all routers.
* Verify IP protocols: `show ip protocols`
* Verify neighbors: `show ip ospf neighbor`
* Verify ospf database: `show ip ospf database`
* Verify connection between PC's: If all other tests have been succesful this should be also succeed. Make sure you can ping every device and interface.
 
**6.2.3.9:**

* Verify OSPFv3 multiarea status: `show ipv6 protocols`
* Verify configuration on all routers: `show ipv6 ospf`
* Verify neighbors: `show ipv6 ospf neighbor`
* Verify routes: `show ipv6 route ospf`
* Verify connection between PC's: If all other tests have been succesful this should be also succeed. Make sure you can ping every device and interface.
 
**6.2.3.10:**

* After the initial setup the network will contain many different mistakes. Once you've finished the lab all of these should be fixed. Finishing every step of the lab succesfully should be enough.
 
**7.2.2.5:**

* Verify connectivity between devices
* Verify neighbors: `show ip eigrp neighbors`
* Verify routes: `show ip eigrp route`
* Verify topology: `show ip eigrp topology`
* Verify protocols: `show ip protocols`
 
**7.4.3.5**

* Verify connectivity between devices
* Verify neighbors: `show ipv6 eigrp neighbors`
* Verify routes: `show ipv6 eigrp route`
* Verify topology: `show ipv6 eigrp topology`
* Verify protocols: `show ipv6 protocols`

### Testrapport

Uitvoerder(s) test: `Matthias Derudder`, `Frederik Van Brussel`, `Daan Van Hecke`

- ...
