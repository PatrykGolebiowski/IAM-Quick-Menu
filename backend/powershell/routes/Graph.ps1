Add-PodeRouteGroup -Path "/api/graph" -Routes {

    ### OpenApi
    # Properties
    New-PodeOAStringProperty -Name "id" -Description "Entra ID or UserPrincipalName" -Required | ConvertTo-PodeOAParameter -In Path | Add-PodeOAComponentParameter -Name "EntraId" 
    New-PodeOAStringProperty -Name "id" -Description "Entra object ID" -Required | ConvertTo-PodeOAParameter -In Path | Add-PodeOAComponentParameter -Name "ObjectId" 
    
    # Request bodies
    Add-PodeOAComponentRequestBody -Name "EntraApplicationBody" -Required -ContentSchemas @{
        "application/json" = (New-PodeOAObjectProperty -Properties @(
            (New-PodeOAStringProperty -Name "DisplayName"),
            (New-PodeOAStringProperty -Name "Notes")
        ))
    }
    Add-PodeOAComponentRequestBody -Name "EmailBody" -Required -ContentSchemas @{
        "application/json" = (New-PodeOAObjectProperty -Properties @(
            (New-PodeOAObjectProperty -Name "message" -Properties @(
                (New-PodeOAStringProperty -Name "subject"),
                (New-PodeOAObjectProperty -Name "body" -Properties @(
                    (New-PodeOAStringProperty -Name "contentType"),
                    (New-PodeOAStringProperty -Name "content")
                )),
                (New-PodeOAObjectProperty -Name "toRecipients" -Properties @( 
                    (New-PodeOAObjectProperty -Name "emailAddress" -Properties @(
                        (New-PodeOAStringProperty -Name "name"),
                        (New-PodeOAStringProperty -Name "address")
                    ))
                )),
                (New-PodeOAObjectProperty -Name "ccRecipients" -Properties @( 
                    (New-PodeOAObjectProperty -Name "emailAddress" -Properties @(
                        (New-PodeOAStringProperty -Name "name"),
                        (New-PodeOAStringProperty -Name "address")
                    ))
                )),
                (New-PodeOAObjectProperty -Name "mentions" -Properties @( 
                    (New-PodeOAObjectProperty -Name "mentioned" -Properties @(
                        (New-PodeOAStringProperty -Name "name"),
                        (New-PodeOAStringProperty -Name "address")
                    ))
                ))
            )),
            (New-PodeOABoolProperty -Name "saveToSentItems")
        ))
    }

    # Schemas
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
    Add-PodeOAComponentSchema -Name "EntraApplicationSchema" -Schema (
        New-PodeOAObjectProperty -Properties @(
            (New-PodeOAStringProperty -Name "id"),
            (New-PodeOAStringProperty -Name "deletedDateTime"),
            (New-PodeOAStringProperty -Name "appId"),
            (New-PodeOAStringProperty -Name "applicationTemplateId"),
            (New-PodeOAStringProperty -Name "identifierUris" -Array),
            (New-PodeOAStringProperty -Name "createdDateTime"),
            (New-PodeOAStringProperty -Name "description"),
            (New-PodeOAStringProperty -Name "disabledByMicrosoftStatus"),
            (New-PodeOAStringProperty -Name "displayName"),
            (New-PodeOABoolProperty -Name "isAuthorizationServiceEnabled"),
            (New-PodeOAStringProperty -Name "isDeviceOnlyAuthSupported"),
            (New-PodeOAStringProperty -Name "isFallbackPublicClient"),
            (New-PodeOAStringProperty -Name "isManagementRestricted"),
            (New-PodeOAStringProperty -Name "groupMembershipClaims"),
            (New-PodeOAStringProperty -Name "nativeAuthenticationApisEnabled"),
            (New-PodeOAStringProperty -Name "notes"),
            (New-PodeOABoolProperty -Name "oauth2RequirePostResponse"),
            (New-PodeOAStringProperty -Name "orgRestrictions" -Array),
            (New-PodeOAStringProperty -Name "publisherDomain"),
            (New-PodeOAStringProperty -Name "signInAudience"),
            (New-PodeOAStringProperty -Name "tags" -Array),
            (New-PodeOAStringProperty -Name "tokenEncryptionKeyId"),
            (New-PodeOAStringProperty -Name "uniqueName"),
            (New-PodeOAStringProperty -Name "defaultRedirectUri"),
            (New-PodeOAStringProperty -Name "samlMetadataUrl"),
            (New-PodeOAStringProperty -Name "serviceManagementReference"),
            (New-PodeOAObjectProperty -Name "addIns" -Array -Properties @(
                (New-PodeOAStringProperty -Name "id"),
                (New-PodeOAObjectProperty -Name "properties" -Properties @(
                    (New-PodeOAStringProperty -Name "key"),
                    (New-PodeOAStringProperty -Name "value")
                )),
                (New-PodeOAStringProperty -Name "type")
            )),
            (New-PodeOAStringProperty -Name "certification"),
            (New-PodeOAObjectProperty -Name "optionalClaims" -Properties @(
                (New-PodeOAObjectProperty -Name "idToken" -Array -Properties @(
                    (New-PodeOAStringProperty -Name "additionalProperties" -Array),
                    (New-PodeOABoolProperty -Name "essential"),
                    (New-PodeOAStringProperty -Name "name"),
                    (New-PodeOAStringProperty -Name "source")
                )),
                (New-PodeOAObjectProperty -Name "accessToken" -Array -Properties @(
                    (New-PodeOAStringProperty -Name "additionalProperties" -Array),
                    (New-PodeOABoolProperty -Name "essential"),
                    (New-PodeOAStringProperty -Name "name"),
                    (New-PodeOAStringProperty -Name "source")
                )),
                (New-PodeOAObjectProperty -Name "saml2Token" -Array -Properties @(
                    (New-PodeOAStringProperty -Name "additionalProperties" -Array),
                    (New-PodeOABoolProperty -Name "essential"),
                    (New-PodeOAStringProperty -Name "name"),
                    (New-PodeOAStringProperty -Name "source")
                ))
            )),
            (New-PodeOAObjectProperty -Name "windows" -Properties @(
                (New-PodeOAStringProperty -Name "packageSid")
                (New-PodeOAStringProperty -Name "redirectUris" -Array)
            )),
            (New-PodeOAStringProperty -Name "requestSignatureVerification"),
            (New-PodeOAStringProperty -Name "migrationStatus"),
            (New-PodeOAObjectProperty -Name "api" -Properties @(
                (New-PodeOAStringProperty -Name "requestedAccessTokenVersion"),
                (New-PodeOABoolProperty -Name "acceptMappedClaims"),
                (New-PodeOAStringProperty -Name "knownClientApplications"-Array),
                (New-PodeOAObjectProperty -Name "oauth2PermissionScopes" -Array -Properties @(
                    (New-PodeOAStringProperty -Name "id"),
                    (New-PodeOAStringProperty -Name "adminConsentDisplayName"),
                    (New-PodeOAStringProperty -Name "adminConsentDescription"),
                    (New-PodeOAStringProperty -Name "userConsentDisplayName"),
                    (New-PodeOAStringProperty -Name "userConsentDescription"),
                    (New-PodeOAStringProperty -Name "value"),
                    (New-PodeOAStringProperty -Name "type"),
                    (New-PodeOABoolProperty -Name "isEnabled")
                )),
                (New-PodeOAObjectProperty -Name "preAuthorizedApplications" -Array -Properties @(
                    (New-PodeOAStringProperty -Name "appId"),
                    (New-PodeOAStringProperty -Name "permissionIds" -Array)
                )),
                (New-PodeOAObjectProperty -Name "tokenEncryptionSetting" -Properties @(
                    (New-PodeOAStringProperty -Name "scheme"),
                    (New-PodeOAStringProperty -Name "audience")
                ))
            )),
            (New-PodeOAObjectProperty -Name "appRoles" -Array -Properties @(
                (New-PodeOAStringProperty -Name "allowedMemberTypes" -Array),
                (New-PodeOAStringProperty -Name "description"),
                (New-PodeOAStringProperty -Name "displayName"),
                (New-PodeOAStringProperty -Name "id"),
                (New-PodeOABoolProperty -Name "isEnabled"),
                (New-PodeOAStringProperty -Name "origin"),
                (New-PodeOAStringProperty -Name "value")
            )),
            (New-PodeOAObjectProperty -Name "publicClient" -Properties @(
                (New-PodeOAStringProperty -Name "redirectUris" -Array)
            )),
            (New-PodeOAObjectProperty -Name "info" -Properties @(
                (New-PodeOAStringProperty -Name "termsOfServiceUrl"),
                (New-PodeOAStringProperty -Name "supportUrl"),
                (New-PodeOAStringProperty -Name "privacyStatementUrl"),
                (New-PodeOAStringProperty -Name "marketingUrl"),
                (New-PodeOAStringProperty -Name "logoUrl")
            )),
            (New-PodeOAObjectProperty -Name "keyCredentials" -Array -Properties @(
                (New-PodeOAStringProperty -Name "@odata.type"),
                (New-PodeOAStringProperty -Name "customKeyIdentifier"),
                (New-PodeOAStringProperty -Name "displayName"),
                (New-PodeOAStringProperty -Name "endDateTime"),
                (New-PodeOAStringProperty -Name "key"),
                (New-PodeOAStringProperty -Name "keyId"),
                (New-PodeOAStringProperty -Name "startDateTime"),
                (New-PodeOAStringProperty -Name "type"),
                (New-PodeOAStringProperty -Name "usage")
            )),
            (New-PodeOAObjectProperty -Name "parentalControlSettings" -Properties @(
                (New-PodeOAStringProperty -Array -Name "countriesBlockedForMinors"),
                (New-PodeOAStringProperty -Name "legalAgeGroupRule")
            )),
            (New-PodeOAObjectProperty -Name "passwordCredentials" -Array -Properties @(
                (New-PodeOAStringProperty -Name "customKeyIdentifier"),
                (New-PodeOAStringProperty -Name "displayName"),
                (New-PodeOAStringProperty -Name "endDateTime"),
                (New-PodeOAStringProperty -Name "hint"),
                (New-PodeOAStringProperty -Name "keyId"),
                (New-PodeOAStringProperty -Name "secretText"),
                (New-PodeOAStringProperty -Name "startDateTime")
            )),
            (New-PodeOAObjectProperty -Name "requiredResourceAccess" -Array -Properties @(
                (New-PodeOAObjectProperty -Name "resourceAccess" -Array -Properties @(
                    (New-PodeOAStringProperty -Name "@odata.type")
                )),
                (New-PodeOAStringProperty -Name "resourceAppId")
            )),
            (New-PodeOAObjectProperty -Name "verifiedPublisher" -Properties @(
                (New-PodeOAStringProperty -Name "displayName"),
                (New-PodeOAStringProperty -Name "verifiedPublisherId"),
                (New-PodeOAStringProperty -Name "addedDateTime")
            )),
            (New-PodeOAObjectProperty -Name "web" -Properties @(
                (New-PodeOAStringProperty -Name "redirectUris"-Array),
                (New-PodeOAStringProperty -Name "homePageUrl"),
                (New-PodeOAStringProperty -Name "logoutUrl"),
                (New-PodeOAObjectProperty -Name "redirectUriSettings" -Array -Properties @(
                    (New-PodeOAStringProperty -Name "@odata.type"),
                    (New-PodeOAStringProperty -Name "uri"),
                    (New-PodeOAIntProperty -Name "index")
                )),
                (New-PodeOAObjectProperty -Name "implicitGrantSettings" -Properties @(
                    (New-PodeOABoolProperty -Name "enableIdTokenIssuance"),
                    (New-PodeOABoolProperty -Name "enableAccessTokenIssuance")
                ))
            )),
            (New-PodeOAObjectProperty -Name "spa" -Properties @(
                (New-PodeOAStringProperty -Name "redirectUris" -Array)
            )),
            (New-PodeOAObjectProperty -Name "servicePrincipalLockConfiguration" -Properties @(
                (New-PodeOABoolProperty -Name "isEnabled"),
                (New-PodeOABoolProperty -Name "allProperties"),
                (New-PodeOABoolProperty -Name "credentialsWithUsageVerify"),
                (New-PodeOABoolProperty -Name "credentialsWithUsageSign"),
                (New-PodeOABoolProperty -Name "identifierUris"),
                (New-PodeOABoolProperty -Name "tokenEncryptionKeyId")
            ))
        )
    )

    

    ### Routes
    # GET
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
                Set-PodeResponseStatus -Code 401 -Description "Error: Unauthorized - Check your authentication headers or token." -Exception $_.Exception
            }
            elseif ($statusCode -eq [System.Net.HttpStatusCode]::NotFound) {
                Set-PodeResponseStatus -Code 404 -Description "Error: Not Found - The requested resource does not exist." -Exception $_.Exception
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
    Set-PodeOARequest -Parameters @(ConvertTo-PodeOAParameter -Reference "EntraId") -PassThru |
    Add-PodeOAResponse -StatusCode 200 -Description "Returns a user object" -ContentSchemas @{
        "application/json" = "EntraUserSchema"
    } -PassThru |
    Add-PodeOAResponse -StatusCode 401 -Description "Error: Unauthorized - Check your authentication headers or token." -PassThru |
    Add-PodeOAResponse -StatusCode 404 -Description "Error: Not Found - The requested resource does not exist."
    

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

            Write-PodeJsonResponse -Value $response
        }
        catch [System.Net.WebException] {
            $response = $_.Exception.Response
            $statusCode = $response.StatusCode

            if ($statusCode -eq [System.Net.HttpStatusCode]::Unauthorized) {
                Set-PodeResponseStatus -Code 401 -Description "Error: Unauthorized - Check your authentication headers or token." -Exception $_.Exception
            }
            elseif ($statusCode -eq [System.Net.HttpStatusCode]::NotFound) {
                Set-PodeResponseStatus -Code 404 -Description "Error: Not Found - The requested resource does not exist." -Exception $_.Exception
            }
            else {
                Write-Host "HTTP error code: $statusCode"
            }
        }
        catch {
            # Handle any other non-HTTP exceptions here
            Write-Host "An unexpected error occurred: $_"
        }

        Write-PodeJsonResponse $response

    } -PassThru |
    Set-PodeOARouteInfo -Summary "Retrieve an application object" -Tags "Graph" -PassThru |
    Set-PodeOARequest -Parameters @(ConvertTo-PodeOAParameter -Reference "ObjectId") -PassThru |
    Add-PodeOAResponse -StatusCode 200 -Description "Returns an applications object" -ContentSchemas @{
        "application/json" = "EntraApplicationSchema"
    } -PassThru |
    Add-PodeOAResponse -StatusCode 401 -Description "Error: Unauthorized - Check your authentication headers or token." -PassThru |
    Add-PodeOAResponse -StatusCode 404 -Description "Error: Not Found - The requested resource does not exist."


    # POST
    Add-PodeRoute -Method Post -Path "/applications" -ScriptBlock {
        $body = $WebEvent.Data


        $baseUri = "https://graph.microsoft.com/beta/applications/"
        $headers = @{
            "Authorization" = "Bearer $($WebEvent.Auth.User.Token)"
            "Content-Type"  = "application/json"
        }

        $body = @{
            "displayName" = $body.displayName
            "notes"       = $body.notes 
        } | ConvertTo-Json


        try {
            $response = Invoke-RestMethod -Uri $baseUri -Headers $headers -Method Post -Body $body -ErrorAction Stop
            $response.PSObject.Properties.Remove("@odata.context")

            Write-PodeJsonResponse -Value $response
        }
        catch [System.Net.WebException] {
            $response = $_.Exception.Response
            $statusCode = $response.StatusCode

            if ($statusCode -eq [System.Net.HttpStatusCode]::BadRequest) {
                Set-PodeResponseStatus -Code 400 -Description "Error: Bad request - Invalid request." -Exception $_.Exception
            }
            elseif ($statusCode -eq [System.Net.HttpStatusCode]::Unauthorized) {
                Set-PodeResponseStatus -Code 401 -Description "Error: Unauthorized - Check your authentication headers or token." -Exception $_.Exception
            
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
    Set-PodeOARouteInfo -Summary "Create an application object" -Tags "Graph" -PassThru |
    Set-PodeOARequest -RequestBody (New-PodeOARequestBody -Reference "EntraApplicationBody") -PassThru |
    Add-PodeOAResponse -StatusCode 201 -Description "Returns created application object" -ContentSchemas @{
        "application/json" = "EntraApplicationSchema"
    } -PassThru |
    Add-PodeOAResponse -StatusCode 400 -Description "Error: Bad request - Invalid request." -PassThru |
    Add-PodeOAResponse -StatusCode 401 -Description "Error: Unauthorized - Check your authentication headers or token."
    

    Add-PodeRoute -Method Post -Path "/sendMail" -ScriptBlock {
        $body = $WebEvent.Data


        $baseUri = "https://graph.microsoft.com/beta/me/sendMail"
        $headers = @{
            "Authorization" = "Bearer $($WebEvent.Auth.User.Token)"
            "Content-Type"  = "application/json"
        }

        $body = @{
            "message" = $body.message
            "SaveToSentItems" = $body.SaveToSentItems 
        } | ConvertTo-Json -Depth 4


        try {
            $response = Invoke-RestMethod -Uri $baseUri -Headers $headers -Method Post -Body $body -ErrorAction Stop
            $response.PSObject.Properties.Remove("@odata.context")

            Write-PodeJsonResponse -Value $response -StatusCode 202
        }
        catch [System.Net.WebException] {
            $response = $_.Exception.Response
            $statusCode = $response.StatusCode

            if ($statusCode -eq [System.Net.HttpStatusCode]::BadRequest) {
                Set-PodeResponseStatus -Code 400 -Description "Error: Bad request - Invalid request." -Exception $_.Exception
            }
            elseif ($statusCode -eq [System.Net.HttpStatusCode]::Unauthorized) {
                Set-PodeResponseStatus -Code 401 -Description "Error: Unauthorized - Check your authentication headers or token." -Exception $_.Exception
            
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
    Set-PodeOARouteInfo -Summary "Send an email as logged in user" -Tags "Graph" -PassThru |
    Set-PodeOARequest -RequestBody (New-PodeOARequestBody -Reference "EmailBody") -PassThru |
    Add-PodeOAResponse -StatusCode 202 -Description "Accepted" -PassThru |
    Add-PodeOAResponse -StatusCode 400 -Description "Error: Bad request - Invalid request." -PassThru |
    Add-PodeOAResponse -StatusCode 401 -Description "Error: Unauthorized - Check your authentication headers or token."

}