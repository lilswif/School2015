## Laboverslag-01

- Naam cursist: Van Brussel Frederik
- Bitbucket repo: https://bitbucket.org/lilswif/enterprise-linux-labo/

### Testplan en -rapport

0. Ga op het hostsysteem naar de directory met de lokale kopie van de repository.
1. Voer vagrant status uit <br/>
• je zou één VM moeten zien met naam pu004 en status not created. Als deze toch bestaat, doe dan eerst vagrant destroy -f pu004.
2. Voer vagrant up pu004 uit. <br/>
• Het commando moet slagen zonder fouten (exitstatus 0)
3. Run de tests  <br/>
> cd / <br/>
> sudo bash /vagrant/test/runbats.sh

 The necessary packages should be installed <br/>
 The Apache service should be running <br/>
 The Apache service should be started at boot <br/>
 The MariaDB service should be running <br/>
 The MariaDB service should be started at boot <br/>
 The SELinux status should be ‘enforcing’ <br/>
 Firewall: interface enp0s8 should be added to the public zone <br/>
 Web traffic should pass through the firewall <br/>
 Mariadb should have a database for Wordpress <br/>
 The MariaDB user should have "write access" to the database <br/>
 The website should be accessible through HTTP <br/>
 The website should be accessible through HTTPS <br/>
 The certificate should not be the default one <br/>
 (in test file common.bats, line 94) <br/>
     `[ -z "$(echo ${output} | grep SomeOrganization)" ]' failed <br/> 
 The Wordpress install page should be visible under http://192.0.2.50/wordpress/ <br/>
 MariaDB should not have a test database <br/>
 MariaDB should not have anonymous users <br/>
 16 tests, 1 failure <br/>

4 . Surf naar: 192.0.2.50/wordpress


#### Wat ging goed?
De opdracht ging eigenlijk verassend vlot. Ik begin zeer goed te begrijpen hoe ansible werkt, en kan sneller identificeren waar de fouten zich bevinden. Dit maakte dat deze opdracht in 1 les eigenlijk zo goed als af was.

#### Wat ging niet goed?
Het grootste probleem dat ik ondervond lag aan mijn netwerkopstelling thuis en had niet rechtstreeks te maken met deze opdracht.
Mijn virtuele machienes hadden namelijk geen connectie tot het internet, maar konden wel andere hosts in mijn thuis netwerk pingen.

Na heel wat proberen bleek dat zowel mijn accespoint als telenet router als dhcp & dns server fungeerden. Ik heb mijn accespoints dus volledig opnieuw opgesteld zonder DHCP, aangezien je deze van telenet niet kan uizetten.

#### Wat heb je geleerd?

Ansible roles, de scripttaal van ansible beter leren begrijpen en zelf aanpassen, 


#### Waar heb je nog problemen mee?

Op het moment van schrijven heb ik nog geen tijd gevonden om het self signed certificate toe te passen. 

### Referenties
https://github.com/bertvv/lampstack
https://github.com/bertvv/ansible-role-httpd
https://www.linode.com/docs/security/ssl/ssl-apache2-centos