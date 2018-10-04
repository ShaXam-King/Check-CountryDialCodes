# Check-CountryDialCodes
PowerShell scripts to get country dial codes and check MFA phone numbers to match usage country

Get-CountryDialCodes must be run first.  It need only be run once...or you can run it periodically to get phone dial table updates. It saves a file in the default folder.

CheckMFAPhoneCountry - This can be run ad hoc.  It will show any user accounts who's MFA phone number does not match their usage location defined on their account in AAD.  Output is currently only to the screen.
