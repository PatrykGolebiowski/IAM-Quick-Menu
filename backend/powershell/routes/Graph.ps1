Add-PodeRouteGroup -Path "/graph" -Routes {

    Add-PodeRoute -Method Get -Path "/object" -ScriptBlock {
        $identity = $WebEvent.Query["identity"]
        
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
            $objectResponse = Invoke-RestMethod -Uri $objectDetailsUri -Headers $headers
            $objectResponse.PSObject.Properties.Remove("@odata.context")
        }
        catch {
            Set-PodeResponseStatus -Code 404 -Description 'Not found' -Exception $_
        }

        try {
            $licenseResponse = Invoke-RestMethod -Uri $objectLicensesUri -Headers $headers
            $licenseResponse = $licenseResponse.value
            
            $objectResponse | Add-Member -MemberType "NoteProperty" -Name "assignedLicenses" -value $licenseResponse
        }
        catch {
            continue
        }


        Write-PodeJsonResponse -Value $objectResponse

    }

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