# Labo-opdracht Enterprise Linux 15-16

- Student: Frederik Van Brussel
- Repository: https://bitbucket.org/lilswif/enterprise-linux-labo/

De opgave van het labo is gebaseerd op [ansible-skeleton](https://github.com/bertvv/ansible-skeleton), een raamwerk voor het snel opzetten van een Vagrant-omgeving aangestuurd met Ansible. Lees de documentatie voor een goed begrip van de werkwijze.

## Opgave

De bedoeling van het labo is een netwerkdomein op te zetten met een aantal typische services.

De domeinnaam voor het netwerk is `linuxlab.lan` en het bestaat uit twee netwerken:

- 192.0.2.0/24 voor publieke servers die vanop het Internet toegankelijk moeten zijn (de zgn. "DMZ" of "Demilitarized Zone")
- 172.16.0.0/16 voor het interne netwerk. Hier binnen is 172.16.100.0-172.16.199.255 voorbehouden voor werkstations.

Een overzicht van alle hosts (die in de praktijk *niet* allemaal gerealiseerd zullen worden) vind je hieronder:

| Hostnaam     | Alias     | IP             | Functie                 |
| :---         | :---      | :---           | :---                    |
| Host-systeem | -         | 192.0.2.1      | D.i. de pc waarop je    |
|              |           | 172.16.0.1     | de labo's uitvoert      |
| r001         | gw        | 192.0.2.254    | Router                  |
|              |           | 172.16.255.254 |                         |
| pu001        | ns1       | 192.0.2.10     | Master DNS              |
| pu002        | ns2       | 192.0.2.11     | Slave DNS               |
| pu003        | mail      | 192.0.2.20     | Mail server             |
| pu004        | www       | 192.0.2.50     | Webserver (LAMP)        |
| pr001        | dhcp      | 172.16.0.1     | DHCP server             |
| pr002        | directory | 172.16.0.2     | LDAP server             |
| pr010        | inside    | 172.16.0.10    | Intranet (LAMP)         |
| pr011        | files     | 172.16.0.11    | Fileserver (Samba, FTP) |
| ws0001       |           | -              | Werkstation             |


