function Get-CsProxyAddress {
    <#
    .SYNOPSIS
    Checks a user for matching SIP and primary SMTP address.
    .DESCRIPTION
    Checks a user for matching SIP and primary SMTP address.
    .PARAMETER SAMAccount
    Required, defines the user to check. This gather all the proxyaddresses that has been defined in Active Directory, then find the SIP and primary SMTP to match later.
    .EXAMPLE
    Get-CsProxyAddress SAMAccountName
    #>
    Param (
        [Parameter(
            Position = 0, ParameterSetName = "SingleUser", Mandatory, HelpMessage = "Users SAMAccountName.")]
        [string]$SAMAccount,
        [Parameter(
            ParameterSetName = "Everyone", HelpMessage = "Switch to check your entire Skype installation for discrepancy.")]
        [switch]$FullScan,
        [Parameter(
            ParameterSetName = "Everyone", HelpMessage = "Show all users tested, errors or not")]
        [switch]$AllResults
    )
    function proxyExtract {
        $sip = $null
        $smtp = $null
        foreach ($proxy in ($_).ProxyAddresses) {
            if ($proxy -like "sip:*") {
                $sip = $proxy.substring(4)
            }
            if ($proxy -clike "SMTP:*") {
                $smtp = $proxy.substring(5)
            }
        }
        $result = [PSCustomObject]@{
            sip = $sip
            smtp = $smtp
        }
        return $result
    }
    if ($FullScan) {
        $userlist = Get-AdUser -Filter 'msRTCSIP-UserEnabled -eq $true' -properties ProxyAddresses,msRTCSIP-PrimaryUserAddress
    } else {
        $userlist = Get-AdUser $SAMAccount -properties ProxyAddresses,msRTCSIP-PrimaryUserAddress
    }
    $userlist | ForEach-Object {
        $proxy = proxyExtract
        if ($proxy.sip -ne $proxy.smtp) {
            Write-Warning "User SIP and SMTP proxyAddress doesn't match."
        } elseif ($proxy.sip -ne ($_."msRTCSIP-PrimaryUserAddress").substring(4)) {
            Write-Warning "ProxyAddress and msRTCSIP-PrimaryUserAddress mismatch."
        }
        if ($AllResults) {
            $result = [PSCustomObject]@{
                SIP = $proxy.sip
                SMTP = $proxy.SMTP
                PrimaryUserAddress = ($_."msRTCSIP-PrimaryUserAddress").substring(4)
            }
            return $result | Format-List
        }
    }
}