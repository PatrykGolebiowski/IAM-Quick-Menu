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

Start-PodeServer -Thread 1 {
    $config = Get-Content -Path ".\config\main.json" | ConvertFrom-Json

    Add-PodeEndpoint -Address $config.ServerProperties.Address -Port $config.ServerProperties.Port -Protocol $config.ServerProperties.Protocol
    
    ### Enable logging
    New-PodeLoggingMethod -Terminal | Enable-PodeErrorLogging
    
    ### Events
    Register-PodeEvent -Type Terminate -Name "Default" -ScriptBlock {

    }

    ### Authentication
    New-PodeAuthScheme -Bearer | Add-PodeAuth -Name "AzureCustom" -Sessionless -ScriptBlock {
        param()

        return @{User = $user }
    }


    ### Routes
    Use-PodeRoutes -Path ".\routes\ActiveDirectory.ps1"

}
