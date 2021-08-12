# Fetching Instance Metadata details - Azure

## Command to fetch all
curl -H Metadata:true --noproxy "*" "http://169.254.169.254/metadata/instance?api-version=2021-02-01" | jq

## Command to fetch compute details
curl -H Metadata:true --noproxy "*" "http://169.254.169.254/metadata/instance/compute?api^Cersion=2021-02-01" | jq

## Command to fetch particular network interface details
curl -H Metadata:true --noproxy "*" "http://169.254.169.254/metadata/instance/network/interface/0?api-version=2021-02-01" | jq

### Output of command to fetch all

        adminuser@poc-eastus2-web-vm-01:~$ curl -H Metadata:true --noproxy "*" "http://169.254.169.254/metadata/instance?api-version=2021-02-01" | jq
          % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                         Dload  Upload   Total   Spent    Left  Speed
        100  2463  100  2463    0     0   231k      0 --:--:-- --:--:-- --:--:--  240k
        {
          "compute": {
            "azEnvironment": "AzurePublicCloud",
            "customData": "",
            "evictionPolicy": "",
            "isHostCompatibilityLayerVm": "false",
            "licenseType": "",
            "location": "eastus2",
            "name": "poc-eastus2-web-vm-01",
            "offer": "UbuntuServer",
            "osProfile": {
              "adminUsername": "adminuser",
              "computerName": "poc-eastus2-web-vm-01",
              "disablePasswordAuthentication": "true"
            },
            "osType": "Linux",
            "placementGroupId": "",
            "plan": {
              "name": "",
              "product": "",
              "publisher": ""
            },
            "platformFaultDomain": "0",
            "platformUpdateDomain": "0",
            "priority": "Regular",
            "provider": "Microsoft.Compute",
            "publicKeys": [
              {
                "keyData": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDb6Pu7xqGewzDUVoGYhhRQXRa0R8s3LPVtJeoW/e2l92oQYQ56Va/jTl63JNX6Dbd0dT/J8kEm3h8rFqw3Jms9yrKjYBf3aCls/TM+M9Dvv5iWgoOINrozRJ08WCN5gg7VqxB482DU3rjnIduibnbcw1uaGExmkQR1kYWCAP/CJlpx8M4Eg3bBbg6i5odJmLFzxvCXS9UOzm8pLXyX7GfXqgR7Nsvi6nExmXXtBa8Lj4WCnCUZ9fdOm1tG0FmAroyQ2VqquH4GMFE4HUwieGia5YIdnJwKBb2tedaiYZCiuEKbBODqpTlQa1xFUyI75PiF18xOX+4S1s13hNeHTHa5\n",
                "path": "/home/adminuser/.ssh/authorized_keys"
              }
            ],
            "publisher": "Canonical",
            "resourceGroupName": "poc-eastus2-rg-01",
            "resourceId": "/subscriptions/ea19577d-ae3c-4081-be3c-42ed78190083/resourceGroups/poc-eastus2-rg-01/providers/Microsoft.Compute/virtualMachines/poc-eastus2-web-vm-01",
            "securityProfile": {
              "secureBootEnabled": "false",
              "virtualTpmEnabled": "false"
            },
            "sku": "16.04-LTS",
            "storageProfile": {
              "dataDisks": [],
              "imageReference": {
                "id": "",
                "offer": "UbuntuServer",
                "publisher": "Canonical",
                "sku": "16.04-LTS",
                "version": "latest"
              },
              "osDisk": {
                "caching": "ReadWrite",
                "createOption": "FromImage",
                "diffDiskSettings": {
                  "option": ""
                },
                "diskSizeGB": "30",
                "encryptionSettings": {
                  "enabled": "false"
                },
                "image": {
                  "uri": ""
                },
                "managedDisk": {
                  "id": "/subscriptions/ea19577d-ae3c-4081-be3c-42ed78190083/resourceGroups/poc-eastus2-rg-01/providers/Microsoft.Compute/disks/poc-eastus2-web-vm-01_OsDisk_1_9af4fe2f031241cabd18ba701b3cfdb5",
                  "storageAccountType": "Standard_LRS"
                },
                "name": "poc-eastus2-web-vm-01_OsDisk_1_9af4fe2f031241cabd18ba701b3cfdb5",
                "osType": "Linux",
                "vhd": {
                  "uri": ""
                },
                "writeAcceleratorEnabled": "false"
              },
              "resourceDisk": {
                "size": "34816"
              }
            },
            "subscriptionId": "ea19577d-ae3c-4081-be3c-42ed78190083",
            "tags": "",
            "tagsList": [],
            "userData": "",
            "version": "16.04.202106110",
            "vmId": "811c8b3f-1176-4d1d-a4ca-ba5a23b86921",
            "vmScaleSetName": "",
            "vmSize": "Standard_B1s",
            "zone": ""
          },
          "network": {
            "interface": [
              {
                "ipv4": {
                  "ipAddress": [
                    {
                      "privateIpAddress": "10.0.1.4",
                      "publicIpAddress": ""
                    }
                  ],
                  "subnet": [
                    {
                      "address": "10.0.1.0",
                      "prefix": "24"
                    }
                  ]
                },
                "ipv6": {
                  "ipAddress": []
                },
                "macAddress": "6045BD7CB5DB"
              }
            ]
          }
        }
