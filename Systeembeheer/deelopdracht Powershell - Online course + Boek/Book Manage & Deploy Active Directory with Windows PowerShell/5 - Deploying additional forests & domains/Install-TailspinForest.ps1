<#
.SYNOPSIS
Creates a new forest of TailspinToys.com
.DESCRIPTION
Install-TailspinForest tests if the AD-Domain-Services feature is installed, and 
if not, installs it. It then deploys the new forest, TailSpinToys.com on the server,
and installs DNS. This script expects no parameters or inputs, and triggers a restart 
upon completion.
.EXAMPLE
Install-TailSpinForest
Promotes the current server to be the root domain controller of TailSpinToys.com
.NOTES
    Author: Charlie Russel
 Copyright: 2015 by Charlie Russel
          : Permission to use is granted but attribution is appreciated
   Initial: 4/17/2015 (cpr)
   ModHist:
          :
#>

if ( (Get-WindowsFeature -Name AD-Domain-Services).InstallState -ne "Installed" ) {
  Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools 
} 

Import-Module ADDSDeployment
Install-ADDSForest `
      -DomainName 'TailspinToys.com' `
      -DomainNetbiosName 'TAILSPINTOYS' `
      -DomainMode 6 `
      -ForestMode 6 `
      -InstallDns `
      -Force



