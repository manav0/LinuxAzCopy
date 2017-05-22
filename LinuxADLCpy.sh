#!/bin/bash
. AzConfig.properties
. AzScriptLogin.properties

################################################################################
# Filename:LinuxADLCpy.sh 
# Description: This script has been created for uploading files to Azure Data Lake store
#              It serves as a utility based on cross platform CLI script to upload files onto Azure from non-Windows systems specifically Mac OS X or Linux systems
#
# Usage: LinuxADLCpy.sh  -srcFolder -$destAzFolder
# Where
# 		-srcFolder 			-source folder in linux machine
#		-destAzFolder		-destination folder in Azure Data Lake Store
#		-useServiceLogin	-use service account login with cert auth. Enter 'y' to activate.
#
# Authors: Manav Gupta
# Comments: tested on Ubuntu 16.04.1 VM
###############################################################################

	
for ARG in $*
do
case $ARG in
-srcFolder) srcFolder=$2;;
-destAzFolder) destAzFolder=$4;;
-useServiceLogin) useServiceLogin=$6
esac
done


# Switch to Resource manager CLI command mode: commands would use the Azure Resource Manager API instead of legacy Service Management APIs
azure config mode arm

# Connect to an Azure subscription from the Azure Command-Line Interface (Azure CLI)


# Use below statement to login interactively with organizational account. This will output an url and a device code for you to use browser to login. 
#azure login #-u $azureLogin

#Use below statement to login with your service principal with certificate auth
#azure login --service-principal --tenant "$azureTenantId" --username "$servicePrincipal" --certificate-file "$certificateFile" --thumbprint "$certificateThumbprint"


if [ "$useServiceLogin" = "y" ] ; then 
then 
echo "script logging with service principal account and cert auth" 
azure login --service-principal --tenant "$azureTenantId" --username "$servicePrincipal" --certificate-file "$certificateFile" --thumbprint "$certificateThumbprint"
else  
azure login
fi


#Check whether you have multiple subscriptions
azure account list

#Ensure your default subscription is set to the one you want to create your service principal.
azure account set "$azureSubscription"


# To change the default subscription, use the azure account set command, and specify the subscription that you wish to be the default
#azure account set "$subName"

# set a default Azure storage account in environment variables for all the storage commands in the same session.
# this enables you to run the Azure CLI storage commands without specifying the storage account and key explicitly.
#export AZURE_STORAGE_ACCOUNT=$storageAcctName
#export AZURE_STORAGE_ACCESS_KEY=$storageAcctKey


#export container_name=$containerName
#export blob_name=$blobName

# set a default storage account using connection string. get the connection string by command:
#azure storage account connectionstring show <storage_account_name>
#export AZURE_STORAGE_CONNECTION_STRING=$connectionString


# Azure CLI commands to access Azure Storage

echo "Uploading the files..."

#azure datalake store filesystem import "$dataLakeStoreAccountName" "$srcFolder" "$destAzFolder"

# Upload local files to a block blob by default. To specify the type for the blob, you can use the --blobtype parameter.
#azure storage blob upload $srcFilePath $containerName $blobName
#find *.gz -exec azure storage blob upload {} $containerName /{} \;
#find $srcFolder -exec azure storage blob upload {} $containerName testFolder/basename{} \;
for f in $srcFolder
do
  echo "Uploading $f file..."
 # azure storage blob upload $f $container_name $destAzFolder/$(basename $f)
 azure datalake store filesystem import "$dataLakeStoreAccountName" "$f" "$destAzFolder/$(basename $f)"
  #cat $f
done

#echo "Listing the files after uploading..."
azure datalake store filesystem list "$dataLakeStoreAccountName" "$destAzFolder"
#azure datalake store account delete $dataLakeStoreAccountName

#echo "Done"