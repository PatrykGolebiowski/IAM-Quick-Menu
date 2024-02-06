Add-PodeRouteGroup -Path "/api/activedirectory" -Routes {

    Add-PodeRoute -Method Get -Path "/object" -ScriptBlock {
        $domain = $WebEvent.Query["domain"]
        $identity = $WebEvent.Query["identity"]

        if (!$identity -or !$domain) {
            Set-PodeResponseStatus -Code 400 -Description "Invalid query" -Exception $_
        }

        $properties = @(
            "c",
            "canonicalName",
            "city",
            "cn",
            "co",
            "company",
            "country",
            "countryCode",
            "created",
            "createTimeStamp",
            "department",
            "description",
            "directReports",
            "displayName",
            "distinguishedName",
            "division",
            "emailAddress",
            "employeeId",
            "employeeNumber",
            "employeeType",
            "enabled",
            "extensionAttribute1",
            "extensionAttribute2",
            "extensionAttribute3",
            "extensionAttribute4",
            "extensionAttribute5",
            "extensionAttribute6",
            "givenName",
            "l",
            "legacyExchangeDn",
            "mail",
            "mailNickname",
            "manager",
            "modified",
            "modifyTimeStamp",
            "msdsExternalDirectoryObjectId",
            "msdsUserAccountControlComputed",
            "msexchExtensionAttribute16",
            "msexchExtensionAttribute17",
            "msexchExtensionAttribute18",
            "msexchExtensionAttribute20",
            "msexchExtensionCustomAttribute1",
            "msexchExtensionCustomAttribute3",
            "msexchExtensionCustomAttribute4",
            "msexchExtensionCustomAttribute5",
            "msexchRecipientDisplayType",
            "msexchRecipientSoftDeletedStatus",
            "msexchRecipientTypeDetails",
            "msexchRemoteRecipientType",
            "name",
            "o",
            "objectCategory",
            "objectClass",
            "objectGuid",
            "office",
            "organization",
            "ou",
            "passwordExpired",
            "passwordLastSet",
            "passwordNeverExpires",
            "physicalDeliveryOfficeName",
            "postalCode",
            "primaryGroup",
            "primaryGroupId",
            "proxyAddresses",
            "pwdLastSet",
            "samAccountName",
            "samAccountType",
            "showInAddressBook",
            "sn",
            "st",
            "state",
            "streetAddress",
            "surname",
            "targetAddress",
            "title",
            "userAccountControl",
            "userPrincipalName",
            "whenChanged",
            "whenCreated"
        )
        $filter = "(sAMAccountName -eq '$identity') -or (EmailAddress -eq '$identity')"
        $object = Get-ADUser -Filter $filter -Server $domain -Properties *

        if ($object) {
            # Filter the properties directly into a PSCustomObject for clean serialization
            $result = [PSCustomObject]@{}
            foreach ($prop in $properties) {
                if ($null -ne $object.$prop) {
                    $result | Add-Member -NotePropertyName $prop -NotePropertyValue $object.$prop
                }
            }
            $result = ConvertTo-DateTime -Object $result
    
            Write-PodeJsonResponse -Value $result
        }
        else {
            Set-PodeResponseStatus -Code 404 -Description "Not found" -Exception $_
        }

    }
}