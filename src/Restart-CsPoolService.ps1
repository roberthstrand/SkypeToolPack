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
        }
        else {
            Stop-CsWindowsService $Service -ComputerName $server | Out-Null
            Start-CsWindowsService $Service -ComputerName $server | Out-Null
        }
    }
}