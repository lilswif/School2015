## Laboverslag-04 Troubleshooting

- Naam cursist: Van Brussel Frederik
- Bitbucket repo: https://bitbucket.org/lilswif/enterprise-linux-labo/

### Stap 1: Testen Link Layer
A) Alle 2 de kabels waren 'connected' op virtualbox

B) ip link gaf aan dat de enp0s8 niet up stond: <br>

/etc/sysconfig/network-scripts/ifcfg-enp0s8 -> onboot=yes -> sudo reboot

### Stap 2: NetwerkLayer
C) ip a gaf geen ip-adres aan enp0s8 <br>
bron van veel frustratie -> na 2uur prutsen opgelost door men. Van Vreckem. <br/>
Kwam doordat ik een verkeerd ip had ingesteld op de Vbox-Host-only adapter.

### Stap 3: Dns Settings:

-> **/etc/named.conf**<br/>
A) Master ip veranderen naar any<br/>
B) bij de zones alle 192.168.56.in-addr.arpa naar 56.168.192.in-a ddr.arpa veranderen <br/>

-> **/var/named/56.168.192.in-a ddr.arpa**  <br/>
A) 192.168.56.in-addr.arpa naar 56.168.192.in-a ddr.arpa veranderen  <br/>
B) puntjes achter alle domeinen<br/>
C) Zones van beedle en butterfree omwisselen (12&13)<br/><br/>
-> **/var/named/56.168.192.in-addr.arpa**<br/>
A) puntjes achter alle domeinen<br/><br>
-> **/var/named/cynalco.com**<br/>
A) puntjes achter alle domeinen <br/>
B) Ip-addressen van beedle en butterfree omwisselen <br/>
C) CNAME aanmaken voor mankey, de alias is files. <br/>
D) Nieuw NS record aanmaken voor de 2de dns server tamatama<br/>
<br/><br/>
### Stap 4: Services (her)starten en controleren 
A) sudo named-checkconf /etc/named.conf <br/>
B) Sudo Systemctl enable named.Service <br/>
C) Sudo Systemctl (re)start named.service <br/>
D) Sudo firewall-cmd --add-service=dns <br/>

### Stap 5: Dig Controle op host
dig @192.168.56.42 tamatama.cynalco.com 