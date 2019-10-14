function Get-CsAvailableNumber {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0, HelpMessage = "Define the number you want to start the search at")]
        [int]
        $StartNumber,
        [Parameter(Mandatory, Position = 1, HelpMessage = "Define the number you want to stop at")]
        [int]
        $EndNumber,
        [Parameter(HelpMessage = "Shows all available numbers")]
        [switch]
        $ShowAll
    )
    # Burde bruker -filter for å gjøre søk kortere
    $users = Get-CsUsers | Where-Object {$_.EnterpriseVoice -eq $true}
    Foreach ($number in ($StartNumber..$EndNumber)) {
        if ($users -notcontains $number) {
            Write-Host $number
            if (!$ShowAll) {
                break
            }
        }
    }
}