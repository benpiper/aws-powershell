param (
    [Parameter(Mandatory)] [string]$hostname,
    [Parameter(Mandatory)] [string]$nameserver,
    [Parameter(Mandatory)] [int]$iterations,
    [Parameter(Mandatory)] [int]$sleeptime
)

function Run-NSLookup {
    param (
        [Parameter(Mandatory)] [string]$hostname,
        [Parameter(Mandatory)] [string]$nameserver
    )

    $ns = (nslookup.exe $hostname $nameserver)[-2] 2>$null
    $lookup = [PSCustomObject]@{
        Address = ($ns -split ':')[1].Trim()
    }
    return $lookup.Address
}

function Iterate-NSLookup {
    param (
        [Parameter(Mandatory)] [string]$hostname,
        [Parameter(Mandatory)] [string]$nameserver,
        [Parameter(Mandatory)] [int]$iterations,
        [Parameter(Mandatory)] [int]$sleeptime
    )

    $responses = @{}
    write-host "Working..."

    for ($i=0; $i -lt $iterations; $i++) {
        #Query DNS
        try {$ip = Run-NSLookup -hostname $hostname -nameserver $nameserver }
        catch { "Name resolution failed. Please check the hostname."; exit}

        #if address is in hashtable, increment counter
        if ($responses[$ip] -ge 1) { $responses[$ip]++ }
        else {
            $responses.Add($ip,1)
            Write-Host Resolved unique IP: $ip
        }
        Start-Sleep -seconds $sleeptime
    }

    $recordlist = @()
    $responses.keys | ForEach-Object  {
        $recordlist += New-Object PSObject -Property @{
            'IP'=$_;
            'Count'=$responses[$_];
            'Percent'="{0:p}" -f ($responses[$_]/$iterations)
        }
    }
    return $recordlist
}

$records = Iterate-NSLookup -hostname $hostname -nameserver $nameserver -iterations $iterations -sleeptime $sleeptime
$records | Format-Table -Property ip,count,percent
Write-Host $records.count "unique responses" for $hostname