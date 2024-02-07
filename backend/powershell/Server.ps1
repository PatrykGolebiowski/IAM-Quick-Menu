Import-Module ExchangeOnlineManagement


$config = Get-Content -Path ".\config\main.json" | ConvertFrom-Json
#Connect-ExchangeOnline -CertificateThumbPrint $config.Exchange.CertificateThumbPrint -AppID $config.Auth.ClientId -Organization $config.Exchange.Organization -ShowBanner:$false


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
    }
    catch {
        $message = "An error occurred during download of OpenId configuration: $_"
        $message | Write-PodeErrorLog
    }

    $jwtHeader = Get-JwtHeader -jwt $Token | ConvertFrom-Json
    $jwtPayload = Get-JwtPayload -jwt $Token | ConvertFrom-Json

    # Check if the kid matches
    if (-not ($discoveryKeys.keys.kid -contains $jwtHeader.kid)) {
        Write-PodeErrorLog "Kid does not match"
        return $false
    }

    # Check if the token is expired
    if ($currentTimeUnix -ge $jwtPayload.exp) {
        Write-PodeErrorLog "Token is expired"
        return $false
    }

    # Check if clientid matches
    if (-not ($jwtPayload.appid -eq $ClientId)) {
        Write-PodeErrorLog "ClientId does not match"
        return $false
    }

    return $true
}


Start-PodeServer -Thread 1 {
    Add-PodeEndpoint -Address $config.ServerProperties.Address -Port $config.ServerProperties.Port -Protocol $config.ServerProperties.Protocol

    ### Enable logging
    New-PodeLoggingMethod -Terminal | Enable-PodeErrorLogging


    
    ### Authentication
    # Bearer auth
    New-PodeAuthScheme -Bearer | Add-PodeAuth -Name "Bearer" -ArgumentList $config -Sessionless -ScriptBlock {
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

        return $null
    }

    # Azure auth
    Enable-PodeSessionMiddleware -Duration 120 -Extend

    $scheme = New-PodeAuthAzureADScheme -ClientID $config.Auth.ClientId -ClientSecret $config.Auth.ClientSecret -Tenant $config.Auth.TenantId
    $scheme | Add-PodeAuth -Name "AzureAD" -SuccessUrl "/" -ScriptBlock {
        param($user, $accessToken, $refreshToken, $response)
        # check if the user is valid
        return @{ User = $user }
    }


    ### Middlewares
    Add-PodeAuthMiddleware -Name "ApiAuthValidation" -Authentication "Bearer" -Route "/api/*"
    Add-PodeAuthMiddleware -Name "DocAuthValidation" -Authentication "AzureAD" -Route "/docs/*"
        

    ### Events
    Register-PodeEvent -Type Terminate -Name "Default" -ScriptBlock {

    }


    ### Routes
    Enable-PodeOpenApi -Path "/docs/openapi" -Title "IAM-Quick-Menu" -Version "0.0.1" -RouteFilter "/api/*"
    Enable-PodeOpenApiViewer -Path "/docs/swagger" -Title "IAM-Quick-Menu" -OpenApi "/docs/openapi" -Type Swagger -DarkMode   

    Use-PodeRoutes -Path ".\routes\ActiveDirectory.ps1"
    Use-PodeRoutes -Path ".\routes\Graph.ps1"
    Use-PodeRoutes -Path ".\routes\ExchangeOnline.ps1"


}
