function ConvertTo-DateTime($Object) {
    <#
    .SYNOPSIS
    Converts DateTime properties of an object to formatted strings.

    .DESCRIPTION
    The ConvertTo-DateTime function iterates through all the properties of the specified object.
    If a property is of type DateTime, it converts the DateTime value to a formatted string.
    The format used is "dddd, MMMM dd, yyyy hh:mm:ss tt".

    .PARAMETER Object
    The object whose DateTime properties should be formatted.

    .EXAMPLE
    $user = Get-MgUser -UserId $userId -Select $userProperties
    $formattedUser = ConvertTo-DateTime $user

    This example gets a user object with the Get-MgUser cmdlet, and then formats the DateTime properties
    of the user object using the ConvertTo-DateTime function.

    .OUTPUTS
    PSCustomObject
    The function returns a new custom object with the formatted DateTime properties.
    #>

    $propertyValues = @{}
    $Object.PSObject.Properties | ForEach-Object {
        if ($_.Value -is [DateTime]) {
            $formattedDate = $_.Value.ToString("dddd, MMMM dd, yyyy hh:mm:ss tt", [Globalization.CultureInfo]::InvariantCulture)
            $propertyValues[$_.Name] = $formattedDate
        }
        else {
            $propertyValues[$_.Name] = $_.Value
        }
    }

    $result = [PSCustomObject]$propertyValues
    return $result
}

function Test-GraphApiAccess ($Token) {

    Write-Debug -Message "Testing Graph API access"

    $headers = @{
        "Authorization" = "Bearer $Token"
    }
    
    try {
        $response = Invoke-RestMethod -Uri "https://graph.microsoft.com/v1.0/me/" -Headers $headers

        $result = @{
            DisplayName = $response.displayName
            GivenName   = $response.givenName
            Surname     = $response.surname
            Token       = $Token
        }
        return $result
    }
    catch {
        return $false
    }
}

function Test-JwtToken ($Token, $ClientId) {
    $currentTimeUnix = [DateTimeOffset]::Now.ToUnixTimeSeconds()

    try {
        $openidConfig = (Invoke-WebRequest -Uri "https://login.microsoftonline.com/common/.well-known/openid-configuration").Content | ConvertFrom-Json
        $discoveryKeys = (Invoke-WebRequest -Uri $openidConfig.jwks_uri).Content | ConvertFrom-Json

        $jwtHeader = Get-JwtHeader -jwt $Token | ConvertFrom-Json
        $jwtPayload = Get-JwtPayload -jwt $Token | ConvertFrom-Json

        if ($discoveryKeys.keys.kid -contains $jwtHeader.kid) {
            if ($currentTimeUnix -lt $jwtPayload.exp) {
                if ($ClientId -eq $jwtPayload.appid ) {
                    return $true
                }
                else {
                    $message = "App id does not match"
                    $message | Write-PodeErrorLog
                }
            }
            else {
                $message = "Token is expired"
                $message | Write-PodeErrorLog
            }
        }
        else {
            $message = "Kid does not match"
            $message | Write-PodeErrorLog
        }
    }
    catch {
        $message = "An error occurred: $_"
        $message | Write-PodeErrorLog
    }

    return $false
}


Start-PodeServer -Thread 1 {
    $config = Get-Content -Path ".\config\main.json" | ConvertFrom-Json
    Add-PodeEndpoint -Address $config.ServerProperties.Address -Port $config.ServerProperties.Port -Protocol $config.ServerProperties.Protocol
    
    ### Enable logging
    New-PodeLoggingMethod -Terminal | Enable-PodeErrorLogging
    
    ### Authentication
    New-PodeAuthScheme -Bearer | Add-PodeAuth -Name "Auth" -ArgumentList $config -Sessionless -ScriptBlock {
        param($token, $config)

        if ($token) {
            if (Test-JwtToken -Token $token -ClientId $config.Auth.ClientId) {
                try {
                    $user = Test-GraphApiAccess -Token $token
                    Write-Debug -Message "User is authenticated: $($user.DisplayName)"
                    return @{
                        User = $user
                    }

                }
                catch {
                    return $false
                }
            }
        }

        # authentication failed
        return $null
    }

    ### Middlewares
    Add-PodeAuthMiddleware -Name "GlobalAuthValidation" -Authentication "Auth"

    ### Events
    Register-PodeEvent -Type Terminate -Name "Default" -ScriptBlock {

    }


    ### Routes
    Use-PodeRoutes -Path ".\routes\ActiveDirectory.ps1"

}
