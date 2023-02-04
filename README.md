Learning Objectives
Adding Terraform provider
Creating an Azure resource group
Creating a virtual network
Creating a subnet
Creating an internal network interface (NIC)
Creating a Windows virtual machine


Now create the Environment for terram form
1) Powershell install

https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=powershell

$ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; rm .\AzureCLI.msi

2) Install chocolatey
https://chocolatey.org/install

Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

3) Install terraform
choco install terraform


Before writing code we need to integrate with Cloud provider API using the following link
https://registry.terraform.io/
select the provider by clicking the provider link e.g. https://registry.terraform.io/providers/hashicorp/azurerm/latest
copy the code by clicking the “Use Provider” button
Sample code 

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.42.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
}


