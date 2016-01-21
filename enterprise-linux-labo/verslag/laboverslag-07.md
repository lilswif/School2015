## Laboverslag-05 Troubleshooting 2

- Naam cursist: Van Brussel Frederik
- Bitbucket repo: https://bitbucket.org/lilswif/enterprise-linux-labo/


1. Azerty maken: ```sudo loadkeys azerty``` <br/>
3. ```sudo service nmb start``` -> Laat netbios naam werken <br/>
4. ```sudo setsebool -P samba_export_all_rw``` -> bravo-test werkt <br/>
5. Via ```sudo vi /etc/samba/smb.conf``` heb ik de instellingen gecontroleerd. Hier vond ik enkele fouten, zoals bijvoorbeeld geen write_list of valid_users bij elke share.  <br/>
5. Vervolgens de permissies van de shares controleren via ```ls -l -a /srv/shares```. <br/>
6. Op basis van stap 5 heb ik bob eigenaar gemaakt van elke share -> ```sudo chown bob alpha/bravo/charlie/...``` <br/>
7. ```sudo chmod -R xxx``` om dan de juiste permissies te voorzien <br/>
7. Als laatste heb ik samba toegang gegeven tot de firewall met het commando ```sudo firewall-cmd --permanent --add-service=samba``` <br/>
8. Elke service herstarten: ```sudo systemctl restart smb``` & ```sudo systemctl restart firewalld``` <br/>
(9. Als tevreden man naar huis gaan)
