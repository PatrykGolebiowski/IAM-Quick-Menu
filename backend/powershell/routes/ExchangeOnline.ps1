Add-PodeRouteGroup -Path "/api/exchangeonline" -Routes {

    Add-PodeRoute -Method Get -Path "/recipient/:identity" -ScriptBlock {
        $identity = $WebEvent.Parameters["identity"]
        
        # # Properties array
        # $userProperties = @(
        #     "AccountEnabled",
        #     "CreatedDateTime",
        #     "DisplayName",
        #     "GivenName",
        #     "Id",
        #     "LastPasswordChangeDateTime",
        #     "Mail",
        #     "MailNickname",
        #     "ProxyAddresses",
        #     "Surname",
        #     "UserPrincipalName",
        #     "UserType",
        #     "OnPremisesLastSyncDateTime"
        # )

        try {
            $recipient = Get-Recipient -Identity $identity
            $recipient = ConvertTo-DateTime -Object $recipient
        }
        catch {
            Set-PodeResponseStatus -Code 404 -Description 'Not found' -Exception $_
        }

        Write-PodeJsonResponse -Value $recipient

    }


}