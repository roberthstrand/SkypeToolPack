### Get-CSPoolServices
Checks all the services on all computers in a pool. If a service is detected as stopped, the user will have the chance of starting that service. 

**Syntax:** `Get-CSPoolServices -PoolFQDN <string> [-ReportPath] <string>  [<CommonParameters>]`

**Example:** `Get-CSPoolServices -PoolFQDN pool.domain.com`

**Example:** `Get-CSPoolServices -PoolFQDN pool.domain.com -ReportPath C:\temp\report.txt`