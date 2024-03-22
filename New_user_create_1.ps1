<#
Author  : Ravindrakumar

Purpose : Create a single new user in Azure Active directory

#>

#Setup the Azure application registration access using client secret#

$TenantID = Get-Content -Path "C:\Ravi-automate\GraphAPI\User\TenantID.txt"
$ClientID = Get-Content -Path "C:\Ravi-automate\GraphAPI\User\Clientid.txt"
$ClientSecret = Get-Content -Path "C:\Ravi-automate\GraphAPI\User\Secret.txt"

#Authenticate and Obtain the access token

$TokenURL = "https://login.microsoftonline.com/$TenantID/oauth2/v2.0/token"

$body = @{

    client_id = $ClientID 
    client_secret = $ClientSecret
    scope = "https://graph.microsoft.com/.default"
    grant_type = "client_credentials"
}
$Token_response = Invoke-RestMethod -Uri $TokenURL -Body $body -Method Post

$Token_response_token = $Token_response.access_token



$Headers = @{

    Authorization = "Bearer $Token_response_token "
    'Content-Type' = "application/json"
}

$usersURL = "https://graph.microsoft.com/v1.0/users"

$UserName_body = @{

    accountEnabled= $true
    displayName  =  "Krithika Ravindrakumar"
    mailNickname =  "Krithika"
    userPrincipalName = "krithika@RavindrakumarAug2022outlook.onmicrosoft.com"
    passwordProfile = @{
      forceChangePasswordNextSignIn = $true
      password= "xWwvJ]6NMw+bWH-d"

}
}

$UserName_body_json = $UserName_body | ConvertTo-Json


$response = invoke-restmethod -Method Post -Uri $usersURL -Headers $Headers -Body $UserName_body_json

Write-Output "New user created with ID: $($response.id)"



