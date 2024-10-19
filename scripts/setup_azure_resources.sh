# az login 
# Assign the Storage Blob Data Contributor role to a user
# az role assignment create --assignee <user-principal-name-or-object-id> --role "Storage Blob Data Contributor" --scope /subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.Storage/storageAccounts/<storage-account-name>
# Generate a SAS token with write permissions
# az storage container generate-sas --account-name <storage-account-name> --name <container-name> --permissions w --expiry <expiry-date> --output tsv
az group create --location eastus --resource-group TestCloudShell 