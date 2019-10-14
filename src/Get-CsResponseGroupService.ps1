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