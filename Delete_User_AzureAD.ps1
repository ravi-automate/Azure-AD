<#
Author  : Ravindrakumar

Purpose : list users and lastly delete particular user in Azure Active directory

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

}

$usersURL = "https://graph.microsoft.com/v1.0/users"

$list_user = invoke-restmethod -Method Get -Uri $usersURL -Headers $Headers

$list_user_sortuser = $list_user.value | Select-Object -Property displayName, givenName, userPrincipalName,id

#Deleting the user code

#Define the user variable userPrincipalName

$DeleteuserPrincipalName = "*********@********.onmicrosoft.com"

$Queryuser_delete = $list_user.value.Where({$_.userPrincipalName -eq $DeleteuserPrincipalName})

$Queryuser_delete_id = $Queryuser_delete.id

$DeleteURL = "https://graph.microsoft.com/v1.0/users/$Queryuser_delete_id"

$Delete_user = Invoke-RestMethod -Uri $DeleteURL -Method Delete -Headers $Headers

if ($Delete_user -eq "")

{
    write-host " $DeleteuserPrincipalName  user deleted from AD or moved to recyclebin"
}