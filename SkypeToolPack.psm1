# Dot-source functions
. $PSScriptRoot\src\Get-CsProxyAddress.ps1
. $PSScriptRoot\src\Get-CsPoolService.ps1
. $PSScriptRoot\src\Restart-CsPoolService.ps1
. $PSScriptRoot\src\Get-CsResponseGroupService.ps1
. $PSScriptRoot\src\Get-CsAvailableNumber.ps1
# Export Functions
Export-ModuleMember -Cmdlet Get-CsPoolService, Restart-CsPoolService, Get-CsResponseGroupService, Get-CsProxyAddress -Function Get-CsPoolService, Restart-CsPoolService, Get-CsResponseGroupService, Get-CsProxyAddress, Get-CsAvailableNumber