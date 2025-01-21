Write-Host "Testing for: $env:TEST_BASE_URL"

function Test-StatusCode {
    param (
        [int]$StatuCode,
        [int]$ExpectedStatusCode = -1
    )
    if ($ExpectedStatusCode -eq -1 -and $StatuCode -ge 400) {
        Write-Host "Did not retrieve a response with an successful statuscode, instead got $StatuCode"
        exit 1
    } elseif($ExpectedStatusCode -ne -1 -and $StatuCode -ne $ExpectedStatusCode ) {
        Write-Host "Did not retrieve a response with status $ExpectedStatusCode, instead got $StatuCode"
        exit 1
    }
}

function Test-MatchContent {
    param (
        [string]$Content,
        [string]$TestString
    )
    if ( $Content -notmatch  $TestString ) {
        Write-Host "Response content did not contain `"$TestString`"."
        exit 1
    }
}

function Test-Path-Contains-String {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Path,
        [Parameter(Mandatory)]
        [string]$TestString,
        [int]$ExpectedStatusCode = -1
    )

    Write-Host -NoNewline "Testing $Path "

    $response = Invoke-WebRequest -SkipHttpErrorCheck -Uri $($env:TEST_BASE_URL + $Path)
    $statusCode = $response | Select-Object -Expand StatusCode
    Test-StatusCode -StatusCode $statusCode -ExpectedStatusCode $ExpectedStatusCode

    $content = $response | Select-Object -Expand Content
    Test-MatchContent -Content $content -TestString $TestString

    Write-Host "successful."
}

function Test-Post-Path-Contains-String {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Path,
        [Parameter(Mandatory)]
        [string]$TestString,
        [Parameter(Mandatory)]
        [object]$PostParams,
        [int]$ExpectedStatusCode = -1
    )

    Write-Host -NoNewline "Testing $Path "

    $response = Invoke-WebRequest -SkipHttpErrorCheck -Method POST -Body $PostParams -Uri $($env:TEST_BASE_URL + $Path)
    $statusCode = $response | Select-Object -Expand StatusCode
    Test-StatusCode -StatusCode $statusCode -ExpectedStatusCode $ExpectedStatusCode

    $content = $response | Select-Object -Expand Content
    Test-MatchContent -Content $content -TestString $TestString

    Write-Host "successful."
}

Test-Path-Contains-String -Path "/" -TestString "world"
Test-Post-Path-Contains-String -Path "/name" -TestString "Hello Stenden!" -PostParams @{name='Stenden'}