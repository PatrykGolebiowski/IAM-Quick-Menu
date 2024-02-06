Add-PodeRouteGroup -Path "/api/graph" -Routes {

    New-PodeOAStringProperty -Name "id" -Description "Entra ID or UserPrincipalName" -Required | ConvertTo-PodeOAParameter -In Path | Add-PodeOAComponentParameter -Name "Id" 
    Add-PodeOAComponentSchema -Name "EntraUserSchema" -Schema (
        New-PodeOAObjectProperty -Properties @(
            (New-PodeOABoolProperty -Name "accountEnabled"),
            (New-PodeOAStringProperty -Name "createdDateTime"),
            (New-PodeOAStringProperty -Name "displayName"),
            (New-PodeOAStringProperty -Name "givenName"),
            (New-PodeOAStringProperty -Name "id"),
            (New-PodeOAStringProperty -Name "lastPasswordChangeDateTime"),
            (New-PodeOAStringProperty -Name "mail"),
            (New-PodeOAStringProperty -Name "mailNickname"),
            (New-PodeOAStringProperty -Name "proxyAddresses" -Array),
            (New-PodeOAStringProperty -Name "surname"),
            (New-PodeOAStringProperty -Name "userPrincipalName"),
            (New-PodeOAStringProperty -Name "userType"),
            (New-PodeOAStringProperty -Name "onPremisesLastSyncDateTime"),
            (New-PodeOAObjectProperty -Name "assignedLicenses" -Properties @(
                (New-PodeOAStringProperty -Name "id"),
                (New-PodeOAStringProperty -Name "skuId"),
                (New-PodeOAStringProperty -Name "skuPartNumber"),
                (New-PodeOAObjectProperty -Name "servicePlans" -Properties @(
                    (New-PodeOAStringProperty -Name "servicePlanId"),
                    (New-PodeOAStringProperty -Name "servicePlanName"),
                    (New-PodeOAStringProperty -Name "provisioningStatus"),
                    (New-PodeOAStringProperty -Name "appliesTo")
                ))
            ))
        )
    )

    Add-PodeRoute -Method Get -Path "/users/:id" -ScriptBlock {
        $identity = $WebEvent.Parameters["id"]
        
        $baseUri = "https://graph.microsoft.com/beta/users/"
        $headers = @{
            "Authorization" = "Bearer $($WebEvent.Auth.User.Token)"
        }

        # Properties array
        $userProperties = @(
            "AccountEnabled",
            "CreatedDateTime",
            "DisplayName",
            "GivenName",
            "Id",
            "LastPasswordChangeDateTime",
            "Mail",
            "MailNickname",
            "ProxyAddresses",
            "Surname",
            "UserPrincipalName",
            "UserType",
            "OnPremisesLastSyncDateTime"
        )
        # Combine properties into a comma-separated string
        $propertiesString = $userProperties -join ","


        $objectDetailsUri = "$baseUri" + "$identity" + '?$select=' + "$propertiesString"
        $objectLicensesUri = "$baseUri" + "$identity" + "/licenseDetails"
        
        try {
            $objectResponse = Invoke-RestMethod -Uri $objectDetailsUri -Headers $headers -ErrorAction 'Stop'
            $objectResponse.PSObject.Properties.Remove("@odata.context")

            if ($null -ne $objectResponse) {
                try {
                    $licenseResponse = Invoke-RestMethod -Uri $objectLicensesUri -Headers $headers
                    $licenseResponse = $licenseResponse.value
                    
                    $objectResponse | Add-Member -MemberType "NoteProperty" -Name "assignedLicenses" -value $licenseResponse
                }
                catch {
                    Write-Host "Error fetching license information: $_"
                }
            }
            Write-PodeJsonResponse -Value $objectResponse
        }
        catch [System.Net.WebException] {
            $response = $_.Exception.Response
            $statusCode = $response.StatusCode

            if ($statusCode -eq [System.Net.HttpStatusCode]::Unauthorized) {
                Set-PodeResponseStatus -Code 401 -Description "Error: Unauthorized (401). Check your authentication headers or token." -Exception $_.Exception
            }
            elseif ($statusCode -eq [System.Net.HttpStatusCode]::NotFound) {
                Set-PodeResponseStatus -Code 404 -Description "Error: Not Found (404). The requested resource does not exist." -Exception $_.Exception
            }
            else {
                Write-Host "HTTP error code: $statusCode"
            }
        }
        catch {
            # Handle any other non-HTTP exceptions here
            Write-Host "An unexpected error occurred: $_"
        }

    } -PassThru |
    Set-PodeOARouteInfo -Summary "Retrieve a user object" -Tags "Graph" -PassThru |
    Set-PodeOARequest -Parameters @(ConvertTo-PodeOAParameter -Reference "Id") -PassThru |
    Add-PodeOAResponse -StatusCode 200 -Description "Returns a user object" -ContentSchemas @{
        "application/json" = "EntraUserSchema"
    } -PassThru |
    Add-PodeOAResponse -StatusCode 401 -Description "Error: Unauthorized (401). Check your authentication headers or token." -PassThru |
    Add-PodeOAResponse -StatusCode 404 -Description "Error: Not Found (404). The requested resource does not exist."
    


    Add-PodeRoute -Method Post -Path "/applications" -ScriptBlock {
        $properties = $WebEvent.Data


        $baseUri = "https://graph.microsoft.com/beta/applications/"
        $headers = @{
            "Authorization" = "Bearer $($WebEvent.Auth.User.Token)"
            "Content-Type"  = "application/json"
        }

        $body = @{
            "displayName" = $properties.displayName
            "notes"       = $properties.notes 
        } | ConvertTo-Json

        try {
            $response = Invoke-RestMethod -Uri $baseUri -Headers $headers -Method Post -Body $body -ErrorAction Stop
            $response.PSObject.Properties.Remove("@odata.context")
        }
        catch {
            $errorMessage = $_.Exception.Message
            Write-Host "Error: $errorMessage"

            Set-PodeResponseStatus -Code 406 -Description $errorMessage -Exception $_
        }

        Write-PodeJsonResponse $response

    }


    Add-PodeRoute -Method Get -Path "/applications/:id" -ScriptBlock {
        $id = $WebEvent.Parameters['id']


        $baseUri = "https://graph.microsoft.com/beta/applications/"
        $headers = @{
            "Authorization" = "Bearer $($WebEvent.Auth.User.Token)"
        }

        $applicationUri = $baseUri + $id

        try {
            $response = Invoke-RestMethod -Uri $applicationUri -Headers $headers -Method Get -ErrorAction Stop
            $response.PSObject.Properties.Remove("@odata.context")
        }
        catch {
            $errorMessage = $_.Exception.Message
            Write-Host "Error: $errorMessage"

            Set-PodeResponseStatus -Code 406 -Description $errorMessage -Exception $_
        }

        Write-PodeJsonResponse $response

    }

    

}