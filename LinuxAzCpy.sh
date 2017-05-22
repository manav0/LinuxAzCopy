#!/bin/bash
. AzConfig.properties

################################################################################
# Filename:LinuxAzCpy.sh 
# Description: This script has been created for uploading files to Azure Storage account
#              It serves as a utility based on cross platform CLI script to upload files onto Azure from non-Windows systems specifically Mac OS X or Linux systems
#
# Usage: LinuxAzCpy.sh  -srcFolder -destAzFolder
# Where
# 		-srcFolder 		-source folder in linux machine
#		-destAzFolder		-destination folder in Azure Storage Account container
#
# Authors: Manav Gupta
# Comments:  tested on Ubuntu 16.04.1 VM
###############################################################################

	
for ARG in $*
do
case $ARG in
-srcFolder) srcFolder=$2;;
-destAzFolder) destAzFolder=$4;;
esac
done


# Switch to Resource manager CLI command mode: commands would use the Azure Resource Manager API instead of legacy Service Management APIs,
# for working with Azure resources in the Resource Manager deployment model.
azure config mode arm

# Connect to an Azure subscription from the Azure Command-Line Interface (Azure CLI)


# This will output an url and a device code for you to use browser to login. Use azure login to authenticate interactively.
#azure login #-u $user


# To change the default subscription, use the azure account set command, and specify the subscription that you wish to be the default
#azure account set "$subName"

# set a default Azure storage account in environment variables for all the storage commands in the same session.
# this enables you to run the Azure CLI storage commands without specifying the storage account and key explicitly.
export AZURE_STORAGE_ACCOUNT=$storageAccountName
export AZURE_STORAGE_ACCESS_KEY=$storageAccountKey


export container_name=$containerName
export blob_name=$blobName

# set a default storage account using connection string. get the connection string by command:
#azure storage account connectionstring show <storage_account_name>
export AZURE_STORAGE_CONNECTION_STRING=$connectionString


# Azure CLI commands to access Azure Storage

echo "Uploading the files..."
# Upload local files to a block blob by default. To specify the type for the blob, you can use the --blobtype parameter.
#azure storage blob upload $srcFilePath $containerName $blobName
#find *.gz -exec azure storage blob upload {} $containerName /{} \;
#find $srcFolder -exec azure storage blob upload {} $containerName testFolder/basename{} \;
for f in $srcFolder
do
  echo "Uploading $f file..."
  azure storage blob upload $f $container_name $destAzFolder/$(basename $f)
  #cat $f
done

#echo "Listing the blobs after uploading..."
#azure storage blob list $container_name
#azure storage delete $container_name file.txt

#echo "Done"