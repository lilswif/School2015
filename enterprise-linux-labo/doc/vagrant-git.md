## Cheat sheet en checklists

- Naam cursist: Van Brussel Frederik
- Bitbucket repo: https://bitbucket.org/lilswif/enterprise-linux-labo/

### Vagrant commando's

| Commando | Beschrijving |
| :--- | :--- |
| vagrant box add | allows you to install a box (or VM) to the local machine. |
| vagrant box remove | removes a box from the local machine. |
| vagrant box list | lists the locally installed Vagrant boxes. |
| vagrant init | initializes a project to use Vagrant. |
| vagrant up |This command is used to create and configure your guest environment/machines based on your Vagrantfile. |
| vagrant status | This command is used to check the status of the Vagrant managed machines. | 
| vagrant reload | This command is used to do a complete reload on the Vagrantfile. Use this command anytime you make a change to the Vagrantfile. This command will do the same thing as running a halt command and then running an up command directly after. |
| vagrant halt | Executing this is self-explanatory, bring down the environment Vagrant is managing. |
| vagrant suspend | This command suspends the environment instead of shutting it down. Enables a quicker startup of the environment when brought back up later. |
| vagrant resume | Command is used after putting environment in a suspended state. |
| vagrant destroy | Beware. This command will bring down the environment if running and then destroys all of the resources that were created along with the initial creation. |
| vagrant package | This command is used to package a running virtualbox environment in a re-usable box. |
| vagrant ssh | SSH into you vagrant running machines. |
| vagrant gem | Install Vagrant plugins via RubyGems. |
| vagrant package | Create a distribution of the VM you have running. |
| vagrant <command> –help | Command that will provide man pages for a vagrant command. |

### Commando's

| Taak                   | Commando |
| :---                   | :---     |
| IP-adress(en) opvragen | `ip a`   |

### Git workflow

Eenvoudige workflow voor een éénmansproject

| Taak                                        | Commando                  |
| :---                                        | :---                      |
| Huidige toestand project                    | `git status`              |
| Bestanden toevoegen/klaarzetten voor commit | `git add FILE...`         |
| Bestanden "committen"                       | `git commit -m 'MESSAGE'` |
| Synchroniseren naar Bitbucket               | `git push`                |
| Wijzigingen van Bitbucket halen             | `git pull`                |

### Checklist netwerkconfiguratie

1. Is het IP-adres correct? `ip a`
2. Is de router/default gateway correct ingesteld? `ip r -n`
3. Is er een DNS-server? `cat /etc/resolv.conf`

