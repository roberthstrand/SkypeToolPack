function Get-CsPoolService {
    <#
    .SYNOPSIS
    Check if all services are running on all servers in a pool. If any services are detected as not running, ask the user if they want to start the service.
    .DESCRIPTION
    Check if all services are running on all servers in a pool. If any services are detected as not running, ask the user if they want to start the service.
    .PARAMETER PoolFQDN
    Required, defines the pool to check. This will gather all the names of all the computers in a pool so we can check them one by one.
    .PARAMETER ReportPath
    Use this parameter to set the path where you want to save a dump of all the results. This can be a regular text file.
    .EXAMPLE
    Get-CsPoolService -PoolFQDN pool.domain.com
    .EXAMPLE
    Get-CsPoolService -PoolFQDN pool.domain.com -ReportPath C:\temp\report.txt
    #>
    param (
        [Parameter(Position = 0,
            Mandatory, HelpMessage = "The fully qualified domain name of a Skype for Business pool.")]
        [string]$PoolFQDN,
        [Parameter(HelpMessage = "Path and filename where to store the result from the test. Result will be in plain text.")]
        [string]$ReportPath,
        [Parameter(HelpMessage = "If any services are stopped, automatically start services.")]
        [switch]$Automaticstart
    )
    $servers = (Get-CsPool -identity $PoolFQDN).computers
    Write-Output "Running Get-CsWindowsService on all computers in the pool"
    foreach ($server in $servers) {
        Write-Output "Checking: $server"
        $result = Get-CsWindowsService -ComputerName $server
        Write-Output $result
        if ($ReportPath) {
            Out-File -InputObject $result -FilePath $ReportPath -Append
        }
        if ($result.status -contains "stopped" -and $Automaticstart) {
            Write-Warning "A service has been detected as 'Stopped'. Starting the service automatically now!"
            Start-CsWindowsService -ComputerName $server
            if ($ReportPath) {
                $serviceStartReport = "Stopped services started by user."
                Out-File -FilePath $ReportPath -InputObject $serviceStartReport -Append
            }
        }
        if ($result.status -contains "stopped") {
            Write-Warning "A service is not running. This might result in a bad user experience."
            Write-Output "Would you like to start the service?"
            do {
                $serviceStart = Read-Host "(Y)es or (N)o"
                if ($serviceStart.ToLower() -eq "y") {
                    Start-CsWindowsService -ComputerName $server
                    if ($ReportPath) {
                        $serviceStartReport = "Stopped services started by user."
                        Out-File -FilePath $ReportPath -InputObject $serviceStartReport -Append
                    }
                    break
                }
            } while ($serviceStart.ToLower() -notlike "n")
        }
    }
}
function Restart-CsPoolService {
    Param (
        [Parameter(
            Position = 0, Mandatory, HelpMessage = "The fully qualified domain name of a Skype for Business pool.")]
        [string]$PoolFQDN,
        [Parameter(HelpMessage = "Define a service to restart.")]
        [string]$Service
        )
        $servers = (Get-CsPool -Identity $PoolFQDN).computers
        foreach ($server in $servers) {
            if (!$Service) {
                Stop-CsWindowsService -ComputerName $server | Out-Null
                Start-CsWindowsService -ComputerName $server | Out-Null
            } else {
                Stop-CsWindowsService $Service -ComputerName $server | Out-Null
                Start-CsWindowsService $Service -ComputerName $server | Out-Null
            }
        }
}
function Get-CsResponseGroupService {
    <#
    .SYNOPSIS
    Check if the Response group service is running on all the servers in a pool.
    .DESCRIPTION
    Check if the Response group service is running on all the servers in a pool.
    .PARAMETER PoolFQDN
    Required, defines the pool to check. This will gather all the names of all the computers in a pool so we can check them one by one.
    .PARAMETER ReportPath
    Use this parameter to set the path where you want to save a dump of all the results. This can be a regular text file.
    .EXAMPLE
    Get-CsResponseGroupService -PoolFQDN pool.domain.com
    .EXAMPLE
    Get-CsResponseGroupService -PoolFQDN pool.domain.com -ReportPath C:\temp\report.txt
    #>
    param (
        [Parameter(Position = 0,
            Mandatory, HelpMessage = "The fully qualified domain name of a Skype for Business pool.")]
        [string]$PoolFQDN,
        [Parameter(
            HelpMessage = "Path and filename where to store the result from the test. Result will be in plain text.")]
        [string]$ReportPath,
        [switch]$Automaticstart
    )
    $servers = (Get-CsPool -identity $PoolFQDN).computers
    foreach ($server in $servers) {
        Write-Output $server
        $result = Get-CsWindowsService RTCRGS -ComputerName $server
        Write-Output $result
        if ($result.status -contains "stopped" -and $Automaticstart) {
            Write-Warning "RTCRGS was detected as stopped. Starting it..."
            Start-CsWindowsService RTCRGS -ComputerName $server
            if ($ReportPath) {
                $serviceStartReport = "Stopped services started by user."
                Out-File -FilePath $ReportPath -InputObject $serviceStartReport -Append
            }
        }
        elseif ($result.status -contains "stopped") {
            Write-Warning "RTCRGS is not running. This might result in a bad user experience."
            Write-Output "Would you like to start the service?"
            do {
                $serviceStart = Read-Host "(Y)es or (N)o"
                if ($serviceStart.ToLower() -eq "y") {
                    Start-CsWindowsService -ComputerName $server
                    if ($ReportPath) {
                        $serviceStartReport = "Stopped services started by user."
                        Out-File -FilePath $ReportPath -InputObject $serviceStartReport -Append
                    }
                    break
                }
            } while ($serviceStart.ToLower() -notlike "n")
        }
        if ($ReportPath) {
            Out-File -FilePath $ReportPath -InputObject $results -Append
        }
    }
}
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
            Position = 0, Mandatory, HelpMessage = "Users SAMAccountName.")]
        [string]$SAMAccount
        )
        $user = Get-AdUser $SAMAccount -properties ProxyAddresses | Select-Object -ExpandProperty ProxyAddresses
        foreach ($proxy in $user) {
            if ($proxy -like "sip:*") {
                $sip = $proxy.substring(4)
            }
            if ($proxy -clike "SMTP:*") {
                $smtp = $proxy.substring(5)
            }
        }
        Write-Output "SIP: $sip"
        Write-Output "SMTP: $smtp"
        if ($sip -match $smtp) {
            Write-Output "SIP & SMTP matches!"
        } else {
            Write-Error "SIP & SMTP does not match!"
        }
}
Export-ModuleMember -Function Get-CsPoolService, Restart-CsPoolService, Get-CsResponseGroupService, Get-CsProxyAddress -Alias gpool, rpool, grgs, gprox -Cmdlet Get-CsPoolService, Restart-CsPoolService, Get-CsResponseGroupService