# **************************************
#
# Script Name: Promote-myFirstDC.ps1
#
# ModHist: 23 Mar, 2014 -- Initial
#        : 13 Mar, 2015 -- added SecureString
#
# **************************************
#
$pwdSS = ConvertTo-SecureString -String "P@ssw0rd!" -AsPlainText -Force

Import-Module ADDSDeployment
Install-ADDSForest `
      -DomainName 'TreyResearch.net' `
      -DomainNetbiosName 'TREYRESEARCH' `
      -DomainMode 6 `
      -ForestMode 6 `
      -NoDnsOnNetwork `
      -SkipPreChecks `
      -SafeModeAdministratorPassword $pwdSS `
      -Force



