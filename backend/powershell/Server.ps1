Start-PodeServer -Thread 1 {
    ### Attach to port 8080 for http
    Add-PodeEndpoint -Address "localhost" -Port 8080 -Protocol Http
    
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


}
