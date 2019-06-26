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
            Position = 1, ParameterSetName = "SingleUser", HelpMessage = "Any organizational unit that should not be searched")]
        [array]$ExcludeOU = $false,
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
    function returnResult {
        $result = [PSCustomObject]@{
            SIP = $proxy.sip
            PrimaryUserAddress = ($_."msRTCSIP-PrimaryUserAddress").substring(4)
            SMTP = $proxy.SMTP
        }
        return $result | Format-List
    }
    if ($FullScan) {
        # Create userlist with all Skype-enabled users in AD
        $userlist = Get-AdUser -Filter 'msRTCSIP-UserEnabled -eq $true' -properties ProxyAddresses,msRTCSIP-PrimaryUserAddress | Where-Object {$_.DistinguishedName -notmatch $ExcludeOU}
    } else {
        # Create userlist based on the SAMAccount specified
        $userlist = Get-AdUser $SAMAccount -properties ProxyAddresses,msRTCSIP-PrimaryUserAddress | Where-Object {$_.DistinguishedName -notmatch $ExcludeOU}
    }
    $userlist | ForEach-Object {
        $proxy = proxyExtract
        if ($proxy.sip -ne $proxy.smtp) {
            # Write warning about proxy mismatch and return result
            Write-Warning "User SIP and SMTP proxyAddress doesn't match."
            returnResult
        } elseif ($proxy.sip -ne ($_."msRTCSIP-PrimaryUserAddress").substring(4)) {
            # Write warning about SfB Primary User Address not matching SIP-Proxyaddress and return result
            Write-Warning "ProxyAddress and msRTCSIP-PrimaryUserAddress mismatch."
            returnResult
        }
        if ($AllResults -or $SAMAccount) {
            returnResult
        }
    }
}