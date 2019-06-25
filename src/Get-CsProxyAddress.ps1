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
        [switch]$FullScan
    )
    function proxyExtract {
        param (
            [Parameter(Position = 0)]
            [string]$proxyUser
        )
        $sip = $null
        $smtp = $null
        foreach ($proxy in ($proxyuser).ProxyAddresses) {
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
        $user = (Get-CsUser).SAMAccountName | Get-AdUser -properties ProxyAddresses,msRTCSIP-PrimaryUserAddress
    } else {
        $user = Get-AdUser $SAMAccount -properties ProxyAddresses,msRTCSIP-PrimaryUserAddress
    }
    foreach ($adUser in $user) {
        $proxy = proxyExtract -proxyUser $adUser
        if ($proxy.sip -ne $proxy.smtp) {
            Write-Warning "User SIP and SMTP proxyAddress doesn't match."
        } elseif ($proxy.sip -ne ($adUser."msRTCSIP-PrimaryUserAddress").substring(4)) {
            Write-Warning "ProxyAddress and msRTCSIP-PrimaryUserAddress mismatch."
        }
        $result = [PSCustomObject]@{
            SIP = $proxy.sip
            SMTP = $proxy.SMTP
            PrimaryUserAddress = ($adUser."msRTCSIP-PrimaryUserAddress").substring(4)
        }
        return $result | Format-List
    }
}