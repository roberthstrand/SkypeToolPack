# SkypeToolPack
When I started working with Skype for Business, I quickly started to write scripts to check the services on some of the Enterprise frontend pools I helped manage. When people started asking for these scripts I figured it would be easier if I made it into a module and published it online.

### Installation
You can install the module manually but when I'm done with a new feature or bug fix I quickly upload the module to [PowerShellGallery](https://www.powershellgallery.com/packages/SkypeToolPack/). You can easily install the module with the following:

```powershell
Install-Module -Name SkypeToolPack
```

For the majority of the cmdlets, you need to have the Skype for Business administration tools installed on the machine but some cmdlets require the *ActiveDirectory* module. 

# The cmdlets, examples and tips
## Get-CSPoolService
Checks all the services on all computers in a pool. If a service is detected as stopped, the user will have the chance of starting that service. 

#### Syntax: 
```powershell
Get-CSPoolService -PoolFQDN <string> [-ReportPath] <string>  [<CommonParameters>]
```

#### Example: 
```powershell
Get-CSPoolService -PoolFQDN pool.domain.com
```

#### Example: 
```powershell
Get-CSPoolService -PoolFQDN pool.domain.com -ReportPath C:\temp\report.txt
```

## Restart-CsPoolService
Restarts all services on all computers in a pool, or a single service on all computers in a pool if spesified.

## Get-CsProxyAddress
Checkes the SIP and SMTP to see if it matches.

#### Syntax: 
```powershell
Get-CsProxyAddress -SAMAccount <string>  [<CommonParameters>]
```

#### Example: 
```powershell
Get-CsProxyAddress username
```