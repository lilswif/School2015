## Laboverslag-05 FileServer met Samba en VSFTPD

- Naam cursist: Van Brussel Frederik
- Bitbucket repo: https://bitbucket.org/lilswif/enterprise-linux-labo/

### Testplan en -rapport

1. Voor de testen voer je alles uit op de host. Alles de virtuele machine up & running is;

1) Samba testen (op lunix)
-> Op je file explorer en typ in de adresbalk smb:///
JE ziet vervolgens een map linuxlab, met daarin alle folders die je aangemaakt hebt (en waarvoor je permissies hebt).

2) VSFTP testen
Bezoek op een browser naar keuze het ip 172.16.0.11 en log je in met fred:fred. Je ziet nu alle mappen die je hebt aangemaakt.


#### Wat ging goed?
Samba ging relatief vlot. Ik kon makkelijk de errors achterhalen en op die manier vooruitgang maken. Een ansible rol maken op basis van uw skeleton is nu ook echt kinderspel!


#### Wat ging niet goed?
Soms was deze opdracht enorm frustrerend omdat de ene error de andere opvolgde. Bij samba kon ik nog makkelijk op basis van de errors vooruitgang maken, wat totaal niet geval was bij VSTFPD. Vaak werkte het niet zonder enige vorm van error, wat troubleshooting echt moeilijk maakte. Door samen te werken met andere mensen kon ik het uiteindelijk toch werkende krijgen. Essentiële stappen waren de SELinux instellingen, de firewall en de root share instellen(!). Dit laatste heb ik zelf niet gevonden.


#### Wat heb je geleerd?

- Zelf een ansible rol maken 
- Ondervonden dat samba geen eitje is om op te stellen, maar ik begrijp nu wel beter de werking ervan.
- beter leren troubleshooting op basis van errors 
- VSFTPD, zelf een eigen ftp server m.a.w.


#### Waar heb je nog problemen mee?

