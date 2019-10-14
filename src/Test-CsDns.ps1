function Test-CsDns {
    param (
        [Parameter(Position = 0,
            Mandatory, HelpMessage = "SIP domain you want to check")]
        [string]$SipDomain
    )
    #Test whether internal or external
    if ((Resolve-DnsName lyncdiscoverinternal.$SipDomain -ErrorAction SilentlyContinue) -and (Resolve-DnsName $SipDomain)) {
        $environment = "internal"
    } elseif (!(Resolve-DnsName $SipDomain -ErrorAction SilentlyContinue)) {
        Write-Error "DNS name does not exist"
    } else {
        $environment = "external"
    }
    #Sjekk offentlig DNS om det er external, eller begge delene om det er internal.
    <#
    Internal:
    Lyncdiscoverinternal.$SipDomain, hent ut access edge
    access.$SipDomain basert på LDI
    #>
}