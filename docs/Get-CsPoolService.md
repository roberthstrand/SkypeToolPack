# Get-CSPoolService
Checks all the services on all computers in a pool. If a service is detected as stopped, the user will have the chance of starting that service. 

## Syntax: 
```powershell
Get-CSPoolService -PoolFQDN <string> [-ReportPath] <string>  [<CommonParameters>]
```

## Example: 
```powershell
Get-CSPoolService -PoolFQDN pool.domain.com
```

## Example: 
```powershell
Get-CSPoolService -PoolFQDN pool.domain.com -ReportPath C:\temp\report.txt
```