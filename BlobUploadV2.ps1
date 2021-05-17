#connect to Azure environment using Global Administrator priviliges 
Connect-AzAccount

#create a new resource group in the default subscription
$rgname = Get-AzResourceGroup -Name "Company-Storage-RG"
if(!$rgname)  
{
 $rgname = "Company-Storage-RG"
 $location = "westeurope"
 New-AzResourceGroup -Name $rgname -Location $location
}

#variables 
$rglocation = 'westeurope'
$containerName = 'BlobContainerA'
$fileslocation = "C:\Files to upload\"
$numberOfBatch = 100
#Generate a storage account name with randmon number in the name for uniqueness
$randomnum = ( Get-Random -Minimum 0 -Maximum 99999 ).ToString('00000')
$storageaccountname = "StorageA" + $RandomNum
$storageaccountname2 = "StorageB" + $RandomNum

 
#Create "storage account A" if doesn't exists  
$storageAccount = Get-AzStorageAccount `
                            -ResourceGroupName $rgname `
                            -Name $storageaccountname `
                            -ErrorAction SilentlyContinue
        $context = $storageAccount.Context
 
if(!$storageAccount)  
{  
     $storageAccount = New-AzStorageAccount `
                         -ResourceGroupName $rgname `
                         -Name $storageaccountname `
                         -Location $rglocation `
                         -SkuName Standard_RAGRS `
                         -Kind StorageV2
      $context = $storageAccount.Context    
} 
 
#create container in a specific storage account
Set-AzureRmCurrentStorageAccount -ResourceGroupName $ResourceGroup -Name $StorageName
$container = Get-AzStorageContainer `
                    -Name $containerName `
                   -Context $context `
                  -ErrorAction SilentlyContinue
if(!$container)  
{  
    $container = New-AzStorageContainer `
                      -Name $containerName `
                      -Context $context `
                      -Permission blob    
 } 


#Create "storage account B" if doesn't exists  
$storageAccount2 = Get-AzStorageAccount `
                            -ResourceGroupName $rgname `
                            -Name $storageaccountname2 `
                            -ErrorAction SilentlyContinue
        $context2 = $storageAccount2.Context
 
if(!$storageAccount2)  
{  
     $storageAccount2 = New-AzStorageAccount `
                         -ResourceGroupName $rgname `
                         -Name $storageaccountname2 `
                         -Location $rglocation `
                         -SkuName Standard_RAGRS `
                         -Kind StorageV2
      $context2 = $storageAccount2.Context    
} 

#create container in a specific storage account
Set-AzureRmCurrentStorageAccount -ResourceGroupName $ResourceGroup -Name $StorageName2 
$container = Get-AzStorageContainer `
                    -Name $containerName `
                   -Context $context2 `
                  -ErrorAction SilentlyContinue
if(!$container)  
{  
    $container = New-AzStorageContainer `
                      -Name $containerName `
                      -Context $context2 `
                      -Permission blob    
 } 



#Upload first 100 files in fileslocation to the blob container.
if($container)
{
  $files = Get-ChildItem -Path $fileslocation
  for ($i = 1 ; $i -le $numberOfBatch; $i++)
  {
    foreach ($file in $files)
    {
         $ext = (Split-Path -Path $file -Leaf).Split(".")[1];
         Set-AzStorageBlobContent `
         -File $file `
         -Container $containerName `
         -Blob $([guid]::NewGuid().ToString() + "." + $ext)  `
         -Context $context
     }
   }
}

#copy files from storage A to storage B (the same 100 files we uploaded before)
  for ($i = 1 ; $i -le $numberOfBatch; $i++)
  {
    foreach ($file in $files)
    {
      Start-CopyAzureStorageBlob -Context $Context -SrcContainer $containerName -SrcBlob $file.Name `
      -DestContext $Context2 -DestContainer $containerName -DestBlob $file.Name
    }
  }