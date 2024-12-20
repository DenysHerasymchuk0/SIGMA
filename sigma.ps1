
param (
    [string]$ServiceName,
    [string]$ExpectedStatus = "Running",

    [string]$Path,
    [Alias("v")]
    [int]$Value,
    [Alias("e")]
    [int]$Expect,

    [switch]$Network
)

$apiToken = ""

Write-Host @"
  
  _________.___  ________    _____      _____   Made by Denys Herasymchuk
 /   _____/|   |/  _____/   /     \    /  _  \  
 \_____  \ |   /   \  ___  /  \ /  \  /  /_\  \ 
 /        \|   \    \_\  \/    Y    \/    |    \
/_______  /|___|\______  /\____|__  /\____|__  /
        \/             \/         \/         \/  

"@ -ForegroundColor Red

if (-not $ServiceName -and -not $Path -and -not $Network) {
    Write-Host @"  
                              ____          _   _ _  __
                             |  _ \   /\   | \ | | |/ / 
  _ __ ___   ___  _ __   ___ | |_) | /  \  |  \| | ' /  
 | '_ ` _ \ / _ \| '_ \ / _ \|  _ < / /\ \ | . ` |  <   
 | | | | | | (_) | | | | (_) | |_) / ____ \| |\  | . \ 
 |_| |_| |_|\___/|_| |_|\___/|____/_/    \_\_| \_|_|\_\

"@ -ForegroundColor White

    $apiUrl = "https://api.monobank.ua/personal/client-info"
    $headers = @{
        "X-Token" = $apiToken
    }

    try {
        $response = Invoke-RestMethod -Uri $apiUrl -Headers $headers -Method Get

        Write-Host "`nClient Information:" -ForegroundColor White
        $clientInfo = [PSCustomObject]@{
            "Client Name"       = $response.name
            "Client ID"  = $response.clientId
        }
        $clientInfo | Format-Table -AutoSize

        Write-Host "Accounts:" -ForegroundColor White
        $accounts = $response.accounts | ForEach-Object {
            $balance = [math]::Round($_.balance / 100, 2)
            $maxBalance = ($response.accounts | ForEach-Object { [math]::Round($_.balance / 100, 2) }) | Measure-Object -Maximum | Select-Object -ExpandProperty Maximum

            $category = if ($balance -eq 0) {
                "Beta"
            } elseif ($balance -eq $maxBalance) {
                "Sigma"
            } else {
                "Alpha"
            }

            [PSCustomObject]@{
                "Category"      = $category
                "Account ID"    = $_.id
                "Send ID"       = $_.sendId
                "Balance"       = $balance
                "Credit Limit (UAH)" = [math]::Round($_.creditLimit / 100, 2)
                "Type"          = $_.type
                "Currency Code" = $_.currencyCode
                "Cashback Type" = $_.cashbackType
                "Masked PAN"    = ($_."maskedPan" -join ", ")
                "IBAN"          = $_.iban
            }
        }

        $accounts | Format-Table -AutoSize

        Write-Host "`nJars (Savings):" -ForegroundColor White
        $response.jars | ForEach-Object {
            [PSCustomObject]@{
                "Jar ID"       = $_.id
                "Title"        = $_.title
                "Description"  = $_.description
                "Balance (UAH)"= [math]::Round($_.balance / 100, 2)
                "Goal (UAH)"   = [math]::Round($_.goal / 100, 2)
                "Currency Code"= $_.currencyCode
            }
        } | Format-Table -AutoSize
    } catch {
        Write-Error "An error occurred: $_"
    }

    $jokes = @(
        "Ukrainian Thanksgiving: A Ukrainian is invited to an American Thanksgiving dinner. He walks in, looks at the turkey, and says, 'This is nice, but where is the borscht?'",
        "Ukrainian Mathematics: 'If you have one potato, and I take one potato, how many potatoes do you have left?' The Ukrainian replies, 'Depends, did I make vodka from the first one?'",
        "A Ukrainian woman says to her boyfriend: 'I want a relationship as strong as my grandmother's dumplings!' He asks: 'What, filled with potatoes?' She answers: 'No, filled with love, and you better not forget it!'",
        "My diet is simple: borscht for breakfast, lunch, and dinner, with a side of dumplings, and if I am lucky, a shot of horilka!",
        "A Ukrainians idea of fast food? A plate of dumplings and a jar of homemade pickles - bring it on!",
        "Why do Kozaks never ask for directions? 'Cause we have got the wind, the horses, and enough vodka to guide us anywhere!",
        "When a Ukrainian says, 'I will be back in a minute', prepare for a 3-hour story about the past, present, and future of borscht.",
        "How do you know a Ukrainian is serious? They show you their homemade pickles and say, 'This is for life, not just a snack!'",
        "Ukrainian wisdom: 'A true Kozak never runs, he just walks... slowly, but with style and a jar of horilka!'",
        "If a Ukrainian tells you to bring something to the party, bring borscht. If you bring anything else, be prepared for a lecture!"
    )

    $randomJoke = $jokes | Get-Random

    $words = $randomJoke.Split(" ")

    $line = ""
    foreach ($word in $words) {
        if ($line.Length + $word.Length -gt 60) {
            Write-Host $line -ForegroundColor Red
            $line = $word
        } else {
            if ($line.Length -gt 0) {
                $line += " "
            }
            $line += $word
        }
    }
    if ($line.Length -gt 0) {
        Write-Host $line -ForegroundColor Red
    }

    Write-Host ""
}

if ($ServiceName) {
    Describe "Service Status Test" {
        try {
            $service = Get-Service -Name $ServiceName
            It "Service $ServiceName should be $ExpectedStatus" {
                $service.Status | Should Be $ExpectedStatus
            }
        } catch {
            It "Service $ServiceName should exist" {
                $_.Exception.Message | Should -Contain "Cannot find any service"
            }
        }
    }
}

if ($Path) {
    Describe "Test File Existence" {
        It "File or directory '$Path' should exist" {
            (Test-Path $Path) | Should Be $true
        }
    }
}

if ($Network) {
    Describe "Network Connectivity" {
        It "should be able to connect to the local network interface" {
            $localInterface = "192.168.1.1"
            $response = Test-NetConnection -ComputerName $localInterface -Port 80
            $response.TcpTestSucceeded | Should Be $true
        }

        It "should be able to ping a website" {
            $remoteServer = "apple.com"
            $response = Test-NetConnection -ComputerName $remoteServer -Port 80
            $response.TcpTestSucceeded | Should Be $true
        }

        It "should confirm the network interface is up" {
            $interface = Get-NetAdapter -Name "Ethernet"
            $interface.Status | Should Be "Up"
        }
    }
}

if ($Path -and $Value -and $Expect) {
    Describe "Script Output Validation" {
        It "should get the same value as expected" {
            $output = & $Path $Value
            $output | Should Be $Expect
        }
    }
}

Write-Host ""