## Laboverslag-00

- Naam cursist: Van Brussel Frederik
- Bitbucket repo: https://bitbucket.org/lilswif/enterprise-linux-labo/

### Procedures

n.v.t.

### Testplan en -rapport

n.v.t.


#### Wat ging goed?
- Het werken met git/bitbucket verloopt zeer vlot, en ik denk de algemene principes zeer goed te begrijpen.

- door het vele prutsen met vagrant en ansible heb ik een goed zicht op wat deze proberen te realiseren.

- eenmaal als de error "g /vagrant/scripts/inventory.py --list ([Errno 2]" en "cannot find playbook" opgelost waren, was de opdracht in een stroomversnelling klaar.  
 
#### Wat ging niet goed?

OPGELOST

	 ssh key toevoegen via documentatie op https://confluence.atlassian.com/bitbucket/set-up-ssh-for-git-728138079.html lukt niet. de .bashrc-code wordt niet uitgevoerd bij het heropstarten van de gitbash.

	 .bashrc wordt echter wel erkent door gitbash zelf. ik heb namelijk een kleine functie geschreven om automatisch naar mijn githubfolder te gaan:

	jhome (){
	cd d:/docs/documenten/githubs
	} 

	lijkt me echter niet zo een probleem, aangezien ik het prefereer met sourcetree te werken.

OPGELOST

	ik heb 6u  proberen ansible werkende te krijgen zodat hij alle packages, etc installeert.
	errors bij vagrant up of vagrant provision:

	1) pu004: error: problem running /vagrant/scripts/inventory.py --list ([errno 2] no such file or directory)

	=> ik vermoed dat dit door de guest additions komt, dus heb ik de nieuwe guest additions cd op pu004 gemound, waarna error:

	2) pu004: Cannot find Ansible playbook.

OPGELOST

	Authentication error oplossen via mkpasswd.net -> crypt-sha512

OPGELOST

	Linux-indelingen bepalen of een code werkt of niet in de VM

.
#### Wat heb je geleerd?

- Bitbucket en de ansible
- Unix-indeling
- SSH keys
- vagrant
- 


#### Waar heb je nog problemen mee?

Het volledige labo is normaal volledig gelukt

### Referenties
https://help.github.com/articles/generating-ssh-keys/
https://docs.vagrantup.com/v2/
https://confluence.atlassian.com/bitbucket/set-up-ssh-for-git-728138079.html

https://github.com/KSid/windows-vagrant-ansible
https://github.com/bertvv/ansible-skeleton
https://github.com/bertvv/ansible-skeleton
https://bertvv.github.io/vagrant-presentation/#/
https://github.com/bertvv


