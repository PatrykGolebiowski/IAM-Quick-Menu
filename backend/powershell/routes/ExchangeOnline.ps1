Add-PodeRouteGroup -Path "/api/exchangeonline" -Routes {

    ### OpenApi
    # Properties
    New-PodeOAStringProperty -Name "identity" -Description "Mail or ID" -Required | ConvertTo-PodeOAParameter -In Path | Add-PodeOAComponentParameter -Name "ExchangeOnlineIdentity" 
    New-PodeOAIntProperty -Name "dataOffSet" -Description "Data offset" -Default 1 | ConvertTo-PodeOAParameter -In Query | Add-PodeOAComponentParameter -Name "DataOffSet" 
    
    # Schemas
    Add-PodeOAComponentSchema -Name "ExchangeOnlineRecipientObject" -Schema (
        New-PodeOAObjectProperty -Array -Properties @(
            (New-PodeOAStringProperty -Name "Identity"),
            (New-PodeOAStringProperty -Name "Alias"),
            (New-PodeOAStringProperty -Name "CustomAttribute1"),
            (New-PodeOAStringProperty -Name "CustomAttribute2"),
            (New-PodeOAStringProperty -Name "CustomAttribute3"),
            (New-PodeOAStringProperty -Name "CustomAttribute4"),
            (New-PodeOAStringProperty -Name "CustomAttribute5"),
            (New-PodeOAStringProperty -Name "CustomAttribute6"),
            (New-PodeOAStringProperty -Name "CustomAttribute7"),
            (New-PodeOAStringProperty -Name "CustomAttribute8"),
            (New-PodeOAStringProperty -Name "CustomAttribute9"),
            (New-PodeOAStringProperty -Name "CustomAttribute10"),
            (New-PodeOAStringProperty -Name "CustomAttribute11"),
            (New-PodeOAStringProperty -Name "CustomAttribute12"),
            (New-PodeOAStringProperty -Name "CustomAttribute13"),
            (New-PodeOAStringProperty -Name "CustomAttribute14"),
            (New-PodeOAStringProperty -Name "CustomAttribute15"),
            (New-PodeOAStringProperty -Name "ExtensionCustomAttribute1" -Array),
            (New-PodeOAStringProperty -Name "ExtensionCustomAttribute2" -Array),
            (New-PodeOAStringProperty -Name "ExtensionCustomAttribute3" -Array),
            (New-PodeOAStringProperty -Name "ExtensionCustomAttribute4" -Array),
            (New-PodeOAStringProperty -Name "ExtensionCustomAttribute5" -Array),
            (New-PodeOAStringProperty -Name "EmailAddresses" -Array),
            (New-PodeOAStringProperty -Name "DisplayName"),
            (New-PodeOAStringProperty -Name "FirstName"),
            (New-PodeOABoolProperty -Name "HiddenFromAddressListsEnabled"),
            (New-PodeOAStringProperty -Name "LastName"),
            (New-PodeOAStringProperty -Name "PrimarySmtpAddress"),
            (New-PodeOAStringProperty -Name "RecipientType"),
            (New-PodeOAStringProperty -Name "RecipientTypeDetails"),
            (New-PodeOAStringProperty -Name "WhenMailboxCreated"),
            (New-PodeOAStringProperty -Name "Id"),
            (New-PodeOAStringProperty -Name "Guid")
        )
    )
    Add-PodeOAComponentSchema -Name "ExchangeOnlineEmails" -Schema (
        New-PodeOAObjectProperty -Array -Properties @(
            (New-PodeOAStringProperty -Name "Organization"),
            (New-PodeOAStringProperty -Name "MessageId"),
            (New-PodeOAStringProperty -Name "Received"),
            (New-PodeOAStringProperty -Name "SenderAddress"),
            (New-PodeOAStringProperty -Name "RecipientAddress"),
            (New-PodeOAStringProperty -Name "Subject"),
            (New-PodeOAStringProperty -Name "Status"),
            (New-PodeOAStringProperty -Name "ToIP"),
            (New-PodeOAStringProperty -Name "FromIP"),
            (New-PodeOAIntProperty -Name "Size"),
            (New-PodeOAStringProperty -Name "MessageTraceId"),
            (New-PodeOAStringProperty -Name "StartDate"),
            (New-PodeOAStringProperty -Name "EndDate"),
            (New-PodeOAIntProperty -Name "Index")
        )
    )

    
    Add-PodeRoute -Method Get -Path "/recipient/:identity" -ScriptBlock {
        $identity = $WebEvent.Parameters["identity"]
        
        # Properties array
        $userProperties = @(
            "Identity",
            "Alias",
            "CustomAttribute1",
            "CustomAttribute2",
            "CustomAttribute3",
            "CustomAttribute4",
            "CustomAttribute5",
            "CustomAttribute6",
            "CustomAttribute7",
            "CustomAttribute8",
            "CustomAttribute9",
            "CustomAttribute10",
            "CustomAttribute11",
            "CustomAttribute12",
            "CustomAttribute13",
            "CustomAttribute14",
            "CustomAttribute15",
            "ExtensionCustomAttribute1",
            "ExtensionCustomAttribute2",
            "ExtensionCustomAttribute3",
            "ExtensionCustomAttribute4",
            "ExtensionCustomAttribute5",
            "EmailAddresses",
            "DisplayName",
            "FirstName",
            "HiddenFromAddressListsEnabled",
            "LastName",
            "PrimarySmtpAddress",
            "RecipientType",
            "RecipientTypeDetails",
            "WhenMailboxCreated",
            "Id",
            "Guid"
        )

        try {
            $recipient = Get-Recipient -Identity $identity | Select-Object $userProperties
            $recipient = ConvertTo-DateTime -Object $recipient

            Write-PodeJsonResponse -Value $recipient
        }
        catch {
            Set-PodeResponseStatus -Code 404 -Description 'Not found' -Exception $_
        }


    }  -PassThru |
    Set-PodeOARouteInfo -Summary "Retrieve an Exchange Online object" -Tags "Exchange Online" -PassThru |
    Set-PodeOARequest -Parameters @(ConvertTo-PodeOAParameter -Reference "ExchangeOnlineIdentity") -PassThru |
    Add-PodeOAResponse -StatusCode 200 -Description "Returns Exchange Online object" -ContentSchemas @{
        "application/json" = "ExchangeOnlineRecipientObject"
    } -PassThru |
    Add-PodeOAResponse -StatusCode 401 -Description "Error: Unauthorized - Check your authentication headers or token." -PassThru |
    Add-PodeOAResponse -StatusCode 404 -Description "Error: Not Found - The requested resource does not exist."


    Add-PodeRoute -Method Get -Path "/recipient/:identity/sent-emails" -ScriptBlock {
        $identity = $WebEvent.Parameters["identity"]
        $dateOffSet = $WebEvent.Query["dateOffSet"]

        if(!$dateOffSet){
            $dateOffSet = 1
        }

        $endDate = Get-Date
        $startDate = $endDate.AddDays(-$dateOffSet)

        try {
            $messageTrace = Get-MessageTrace -SenderAddress $identity -StartDate $startDate -EndDate $endDate

            $result = @()
            ForEach($message in $messageTrace) {
                $message = ConvertTo-DateTime -Object $message
                $result += $message
            }

            Write-PodeJsonResponse -Value $result
        }
        catch {
            Set-PodeResponseStatus -Code 404 -Description 'Not found' -Exception $_
        }


    } -PassThru | 
    Set-PodeOARouteInfo -Summary "Retrieve sent e-mails for an Exchange Online object" -Tags "Exchange Online" -PassThru |
    Set-PodeOARequest -Parameters @(
        (ConvertTo-PodeOAParameter -Reference "ExchangeOnlineIdentity"),
        (ConvertTo-PodeOAParameter -Reference "DataOffSet")
    ) -PassThru |
    Add-PodeOAResponse -StatusCode 200 -Description "Returns array of Exchange Online mails" -ContentSchemas @{
        "application/json" = "ExchangeOnlineEmails"
    } -PassThru |
    Add-PodeOAResponse -StatusCode 401 -Description "Error: Unauthorized - Check your authentication headers or token." -PassThru |
    Add-PodeOAResponse -StatusCode 404 -Description "Error: Not Found - The requested resource does not exist."


    Add-PodeRoute -Method Get -Path "/recipient/:identity/received-emails" -ScriptBlock {
        $identity = $WebEvent.Parameters["identity"]
        $dateOffSet = $WebEvent.Query["dateOffSet"]

        if(!$dateOffSet){
            $dateOffSet = 1
        }

        $endDate = Get-Date
        $startDate = $endDate.AddDays(-$dateOffSet)

        try {
            $messageTrace = Get-MessageTrace -RecipientAddress $identity -StartDate $startDate -EndDate $endDate

            $result = @()
            ForEach($message in $messageTrace) {
                $message = ConvertTo-DateTime -Object $message
                $result += $message
            }

            Write-PodeJsonResponse -Value $result
        }
        catch {
            Set-PodeResponseStatus -Code 404 -Description 'Not found' -Exception $_
        }


    } -PassThru | 
    Set-PodeOARouteInfo -Summary "Retrieve received e-mails for an Exchange Online object" -Tags "Exchange Online" -PassThru |
    Set-PodeOARequest -Parameters @(
        (ConvertTo-PodeOAParameter -Reference "ExchangeOnlineIdentity"),
        (ConvertTo-PodeOAParameter -Reference "DataOffSet")
    ) -PassThru |
    Add-PodeOAResponse -StatusCode 200 -Description "Returns Exchange Online object" -ContentSchemas @{
        "application/json" = "ExchangeOnlineEmails"
    } -PassThru |
    Add-PodeOAResponse -StatusCode 401 -Description "Error: Unauthorized - Check your authentication headers or token." -PassThru |
    Add-PodeOAResponse -StatusCode 404 -Description "Error: Not Found - The requested resource does not exist."

}