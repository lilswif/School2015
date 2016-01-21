#Documentatie deelopdracht Window Server 2: Deployment with Powershell

<!---
kjeld: password voor machine: `Admin123`
--->

##Boek: Netwerkbeheer Deel 1

###Hoofdstuk 1: Installatie Windows Server 
1. Na downloaden van Windows Server 2012 r2, installeer je de **core** versie.
2. Na de installatie moet je een passwoord voor Administrator instellen. Dit moet **secure** zijn(Minstens zeven karakters en combinatie van minstens 3 van de volgende: hoofdletters, kleine letters, getallen, overige symbolen; mag ook niet *administrator* bevatten).
3. **Probleem**: Inlog scherm is in qwerty, machine zelf werkt meteen in azerty.
4. Je start enkel met een CMD instance open. Om Powershell te launchen gebruik `start powershell`

######Test
* Herstart de machine en log weer aan, dit kan je doen met de CMDlet `Restart-computer`

###Hoofdstuk 2: Beheren van standalone servers
1. Time zone aanpassen: Om huidige te vinden `[System.TimeZone]::CurrentTimeZone`
2. Je kan een hulp methode aanmaken voor de tijdzone te vinden van plekken:
3. `function Get-TimeZone($Name)`

`{`

 `[system.timezoneinfo]::GetSystemTimeZones() | `
 
 `Where-Object { $_.ID -like "*$Name*" -or $_.DisplayName -like "*$Name*" } | `
 
 `Select-Object -ExpandProperty ID`
 
`}`

4. Nu kan je `get-timezone -Name X` gebruiken. In X plaats je de naam van een stad en krijg je in welke tijdzone deze zit.
5. Brussel zit in de Romance time zone. Staat normaal al goed.
6. Tijd en datum: Om te controleren: `get-date`
7. Met `set-date` kan je deze aanpassen indien nodig. (gewoon -date of (get-date).addhours/min...)
8. Network connections: Met `netsh interface ipv4 show interfaces` of `get-netAdapter` krijg je een lijst van de verbonden network connections (ipv4 in dit geval)
9. Om een connectie naam te veranderen: bv. Ethernet moet lanconnectie heten: `get-netadapter -Name Ethernet | Rename-Netadapter -NewName lanconnectie`
10. Met `get-netAdapterBinding`kan je de properties vinden voor alle verbindingen. IPv6 staat op true maar moet uitgeschakeld worden.
11. IPv6 uitschakelen: `disable-netadapterbinding -Name "*name van verbinding*" -componentID "ms_tcpip6"`.Je kan ze weer inschakelen met `enable-netadapterbinding`. Andere items kan je uitschakelen door compenentid aan te passen naar de naam gevonden in `get-netadapterbinding`
12. IP adres aanpassen: `get-netadapter "*naam verbinding*"|new-netipaddress -ipaddress *X.X.X.X* -prefixlength 24`
13. Naam machine aanpassen: `Rename-computer -newname PFSV1`. WS moet herstarten voor verandering door te voeren.
14. Machine toevoegen aan werkgroep: `Add-computer -workgroupname PFWERKGROEP`

######Test
* herstart zeker eerst de machine voor het testen
* Werkgroep testen: gebruik hulpfunctie: `function get-workgroup {(Get-WmiObject -Class Win32_ComputerSystem).workgroup}`. Als je dan get-workgroup runt krijg je de workgroup.
* ipconfig voor ip adres.
* Voor IPv6 kan je kijken naar `get-netadapterbinding`

###Hoofdstuk 3: Active Directory
1. Om te zien welke services geïnstalleerd zijn: `get-windowsfeature`
2. Je moet **Active Directory Domain Services** installeren.
3. `install-windowsfeature ad-domain-services`
4. Script om PFSV1 DC te maken [hier](http://www.mustbegeek.com/install-domain-controller-in-server-2012-using-windows-powershell/). Het script staat onderaan de pagina. Pas wel de domainname en domainNetBiosName aan.
 
######Practicum 3.2.1


###References
* [Installating AD on WS core](http://blog.coretech.dk/kaj/installing-active-directory-domain-services-on-windows-server-2012-r2-core/)
* [Help functie timezone](http://powershell.com/cs/blogs/tips/archive/2013/08/13/changing-current-time-zone.aspx)
* [Turn off ipv6 and ipv4 in WS 2012 core](https://social.technet.microsoft.com/Forums/en-US/a1bd0436-7f99-43c6-ac55-26e14ba8fb9e/how-disable-ipv6-and-ipv4-in-server-2012-core-by-using-powershell?forum=winserverpowershell)
* [hulpscript workgroup](http://powershell.com/cs/media/p/3939.aspx)
* [Installatie AD DS en promotion naar DC](https://www.brandonlawson.com/active-directory/installing-a-2012-domain-controller-with-powershell/)



