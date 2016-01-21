<#
.Synopsis
   Acquires and imports the Azure PublishSettingsFile
.DESCRIPTION
   Running the Get-AzurePublishSettingsFile will take us to the browser where we'll retrieve our file. 
   Afterwards the variable $PublishFile will try to retrieve the file in the directory specified by the DownloadLocation parameter.
   It will keep trying every 5 seconds until the file is retrieved.
   One acquired it will display the name of the file it acquired and import it. 


   If you notice an infinite loop occuring please check the following:
   1. Have you correctly specified the download path?
   2. Are you logged into azure on your browser?
   3. Has Microsoft changed the way a publishsettings file is named? 
      At the time of the creation of this script it was like this: Azure Pass-11-24-2015-credentials.publishsettings.
      The module is looking for a file constructed like this for the current date (Month-Day-Year).

   4. Is the date specified on the machine correct?
.EXAMPLE
   PS C:\> Acquire-AzurePublishSettingsFile -DownloadLocation 'D:\Downloads Chrome'
    Waiting for the Azure Pass...
    Waiting for the Azure Pass...
    Acquired Azure Pass-11-24-2015-credentials.publishsettings importing pass now
    VERBOSE: Setting: Microsoft.Azure.Common.Extensions.Models.AzureSubscription as the default and current subscription.
    To view other subscriptions use Get-AzureSubscription


    Id          : 03934384-31ca-42e1-94cf-52b1a5002d64
    Name        : Azure Pass
    Environment : AzureCloud
    Account     : B12A5D2B3443DE672F1C84AF3E08D7E11A3B8E59
    Properties  : {[SupportedModes, AzureServiceManagement]}

.NOTES
Author = Matthias Derudder
#>
function Acquire-AzurePublishSettingsFile
{
    [CmdletBinding()]
    Param
    (
        
        [Parameter(Mandatory=$true,
                    HelpMessage='Please specify the path where your default browsers stores your downloads. Example: C:\Users\Administrator\Downloads\')]
        [String[]]$DownloadLocation,
        [Parameter(Mandatory=$true,
                    HelpMessage='Please specify the Subscription Name')]
        [String[]]$SubscriptionName

    )

    Begin
    {
    $PublishFile = $null
    }
    Process
    {
    #Retrieve the file
    Get-AzurePublishSettingsFile

    #Find and assign the file to a variable
    While($PublishFile -eq $null)
    {
    $PublishFile = Get-Childitem -Path $DownloadLocation | where-object {$_.Name.Contains("Azure Pass-"+(get-date).Month+"-"+(get-date).Day+"-"+(get-date).Year+"-credentials.publishsettings")}

    Echo "Waiting for the Azure subscription file..."
    sleep (5)
    }
    "Acquired $PublishFile importing the subscription file now"

    #Importing the file
    Import-AzurePublishSettingsFile $PublishFile.FullName
    Remove-Item $PublishFile.FullName
    }
    End
    {
    }
}