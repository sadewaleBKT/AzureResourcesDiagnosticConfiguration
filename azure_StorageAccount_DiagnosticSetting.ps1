$saList = Get-AzStorageAccount | Select-Object storageAccountName, resourceGroupName, @{l='subcriptionID';e={$_.id.split('/')[2]}}

$LAWS = $args[0]
$LAWS

foreach ($storageItem in $saList){
    $subscription = $storageItem | ForEach-Object { $_.subcriptionID }
    $resourceGroup = $storageItem | ForEach-Object { $_.resourceGroupName }
    $storageAccount = $storageItem | ForEach-Object { $_.storageAccountName }
    $resourceID = "/subscriptions/"+$subscription+"/resourceGroups/"+$resourceGroup+"/providers/Microsoft.Storage/storageAccounts/"+$storageAccount
    $DiagSettingName = $storageAccount+"-diag-01"
    
    Set-AzDiagnosticSetting -ResourceId $resourceID -Name $DiagSettingName -WorkspaceId $LAWS -Enabled $true -MetricCategory Transaction
    
    $Output = "Diagnostic Setting has been enabled for "+$storageAccount+" Storage Account"
    $Output
}
