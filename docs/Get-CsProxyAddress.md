# Get-CsProxyAddress
Checkes the SIP and SMTP to see if it matches.

## Syntax: 
```powershell
Get-CsProxyAddress -SAMAccount <string>   [<CommonParameters>]

Get-CsProxyAddress [-FullScan]
```

## Example: 
Check a users SIP and primary SMTP to make sure it matches
```powershell
Get-CsProxyAddress SAMAccountName
```
Check all users and make a list over users with a difference between SIP and primary SMTP
```powershell
Get-CsProxyAddress -FullScan
```