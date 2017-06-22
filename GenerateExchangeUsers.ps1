<#
Usage: generateUsers.ps1 [number of users to create]
This script will generate Mailbox Enabled users for Exchange.
Run it from the Exchange terminal or it won't work.
#>

param(
   [Parameter(Mandatory=$true)[Int32] $howMany # How many users will be generated. 
)
 
function GenerateName(){
    $roll = Get-Random -Minimum 0 -Maximum 4945
    $name = (Get-Content .\names.txt)[$roll]
    return $name
}
 
$password = Read-Host "Password for all accounts: " -AsSecureString
$database = Read-Host "Database for storage: "
$domain  =  Read-Host "Domain name (including TLD): "
 
For ($i=0; $i -lt $howMany; $i++){
    $firstName = GenerateName
    $lastName  = GenerateName
    $displayName = $firstName[0] + $lastName # As in JDoe or John Doe
    Write-Host "$firstName $lastName, also known as $displayName," , " will be created."
   
    New-Mailbox `
        -UserPrincipalName "$firstName$lastName@$domain" `
        -Alias $displayName `
        -Database $database `
        -Name "$firstName$lastName" `
        -OrganizationalUnit Users `
        -Password $password `
        -FirstName $firstName `
        -LastName $lastName `
        -DisplayName "$firstName $lastName" `
        -ResetPasswordOnNextLogon $true
        # This might not be the best configuration.
}
 
Write-Host "Finished making $howMany mailbox-enabled users." -b Green