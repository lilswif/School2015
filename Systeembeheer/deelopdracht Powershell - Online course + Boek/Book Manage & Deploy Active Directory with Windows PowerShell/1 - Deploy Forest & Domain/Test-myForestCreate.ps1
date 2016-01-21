Import-Module ADDSDeployment
Test-ADDSForestInstallation `
     -DomainName 'TreyResearch.net' `
     -DomainNetBiosName 'TREYRESEARCH' `
     -DomainMode 6 `
     -ForestMode 6 `
     -NoDnsOnNetwork `
     -NoRebootOnCompletion

