<#
.SYNOPSIS
Test the environment to verify that a new forest of TailspinToys.com can be created.

.DESCRIPTION
Test-TailSpinForest tests if the AD-Domain-Services feature is installed, and if not, 
installs it. It then tests the current environment to verify that a new forest, 
TailSpinToys.com can be successfully installed. This script expects no parameters or 
inputs, and does not trigger a restart upon completion.

.EXAMPLE
Test-TailSpinForest
Tests wheter a Promotion of the current server to be the root domain controller of TailSpinToys.com will succeed.

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
Test-ADDSForestInstallation `
      -DomainName 'TailspinToys.com' `
      -DomainNetbiosName 'TAILSPINTOYS' `
      -DomainMode 6 `
      -ForestMode 6 `
      -InstallDNS `
      -Force

