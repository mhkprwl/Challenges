## Fetching value from Nested Object

### Used jq to accomplish the same

![Capture](https://user-images.githubusercontent.com/47051115/129139370-de8923fa-17d1-4616-8604-eee35dd40c26.JPG)

### Text Output of command
     adminuser@poc-eastus2-web-vm-01:~$ cat simple.json
      { "Name":
          {
            "lastname": "Porwal",
            "firstname": "Mahak"
          },
      "Qualifications": "BE",
      "CurrentCompany":
      {
            "name": "Dataglove",
            "designation": "Associate-Consultant"
      },
      "title": "Test JSON",
      "category": ["Non-Fiction", "Technology"]
      }
      adminuser@poc-eastus2-web-vm-01:~$ cat simple.json | jq --raw-output -r '.Name.firstname'
      Mahak
      adminuser@poc-eastus2-web-vm-01:~$ cat simple.json | jq --raw-output -r '.CurrentCompany.designation'
      Associate-Consultant
      adminuser@poc-eastus2-web-vm-01:~$ cat simple.json | jq --raw-output -r '.category'
      [
        "Non-Fiction",
        "Technology"
      ]
      adminuser@poc-eastus2-web-vm-01:~$ cat simple.json | jq --raw-output -r '.category[0]'
      Non-Fiction
      adminuser@poc-eastus2-web-vm-01:~$ date
      Wed Aug 11 20:02:42 UTC 2021
