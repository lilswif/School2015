## Testplan en -rapport taak 1: eenvoudige LAMP stack

* Verantwoordelijke uitvoering: `Daan Van Hecke`
* Verantwoordelijke testen: `Frederik Van Brussel`

### Testplan

Auteur(s) testplan: `Daan Van Hecke`

Testplan opzetten voor:
- Wordpress
- Collectd server doen werken( surfen naar <serverip>/collectd/)
- Framework voor load testers werken op lampstack.
- Collectd web ontvangt metrieken van de lampstack.
- Pingen naar de LAMP webserver.
- Kunnen surfen naar de LAMP webserver.
- Surfen naar IP-addres LAMP server /collectd.
- Surfen naar de wordpress op de LAMP stack.
- Visualiseren van de data door load testing op de collectd.
- Veel load testen en dit duidelijk zien.
- Weinig load testen en dit ook opmerken.
- Een performante webserver opzetten met high availability.
– HA: servers die wegvallen hebben geen invloed op beschikbaarheid voor de gebruikers.
– performant: ook veel gebruikers kunnen tegelijkertijd de webserver gebruiken.
- Monitoren van netwerkservices, opvangen van metrieken.
- Stress-testen van netwerkservices.
- Reproduceerbare experimenten opzetten, resultaten correct analyseren en rapporteren.


### Testrapport

Uitvoerder(s) test: `Frederik Van Brussel`

- De LAMP-webserver opstellen is gelukt via de Ansible role.
- Wordpress is opgevuld met data.
- De collectd server is opgesteld.
- Via Apache JMeter kunnen we de data visualiseren.
- Via Siege kunnen we de data visualiseren.
- De verschillende metrieken analyseren en documenteren.
- Verschillende scenario's van loadtesting.
