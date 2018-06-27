Import-Module MSOnline
Connect-MsolService

# Get the location list from online and save to file (switched)

# Get the usage location from local file

$CountryDialCodes = Import-Csv .\countrydialcodes.csv

Get-MsolUser | Where-Object {$_.StrongAuthenticationMethods -like "*"} | % {

$upn = $_.UserPrincipalName
$ul = $_.UsageLocation
$atriskMFA = $false
$_.StrongAuthenticationUserDetails | % {

  $phone = $_.phonenumber
  $email = $_.email 
  
} # for each StrongAuthenticationDetail

# lookup the Usage location to get the Dial Code
$Dialcode = ($CountryDialCodes | where-object {$_.CountryCode -eq $ul}).dialcode
$Country = ($CountryDialCodes | where-object {$_.CountryCode -eq $ul}).Country
$Countrycode = ($CountryDialCodes | where-object {$_.CountryCode -eq $ul}).Countrycode

#Compare dial code to enrolled MFA phone number
#If they are different then output to screen
if (($phone.split(' ')[0].trim()) -ne ('+' + $Dialcode)) {
    $atriskMFA = $true
    $upn+','+$phone+','+$country+','+$ul+','+$Countrycode
  }

} # end of foreach user
