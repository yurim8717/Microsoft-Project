# Microsoft-Project

This "Microsoft-Project" repository contains several ARM Templates, a Powershell script for Blob upload to storage account and a step by step breakdown of how to deploy the ARM templates in a continous manner via Azure Devops.

Repository contents:
1. ARM-Server-Template folder: Contains the ARM Template files of the Windows Server 2019 configuration for deployment
2. ARM-Storage-Account-template folder:  Contains the ARM Template files of Storage Account configuration for deployment
3. Azure-Monitor-Dashboard-Template folder: Contains the Dashboard with Metrics (from Azure Monitor service) of a specific VM.
4. "BlobUploadV2.ps1" file: A Powershell script that connects to Azure, creates a new resource group, creates Storage Account A with a container and Sotrage Account B with a container, Uploads 100 blobs to Storage Account A and copies the 100 blobs from Storage Account A to Storage Account B.
5. Deployment of "ARM Templates via Azure Devops.pdf" file: Step by step breakdown of how to deploy the ARM templates in a continous manner via Azure Devops.
