# Challenge-1

### 3 Tier Architecture Creation

![image](https://user-images.githubusercontent.com/47051115/129131072-905b9d81-2bf0-4de5-885d-19bf2d872d72.png)

#### Componenets which build up the above Infrastructure:
      1. Single VNET
      2. Two Subnets - One for Frontend (Web) and one for Middle Tier (App)
      3. Two NSGs -  One for Frontend (Web) and one for Middle Tier (App)
      4. Two Linux Virtual Machines - One for Web VM and one for App VM 
      5. Public Load Balancer to allow traffic only to Web VM
      6. MYSQL PaaS DB
      7. KeyVault to store secrets and keys
 
#### Traffic flow
      User ----> Public Load Balalncer ----> Web VM ----> App VM ----> MYSQL DB
   
#### Security Considertaions followed:-
      1. SSH Key Pair is used to build up Virtual Machines instead of username and password.
      2. SSH Key Pair for each Virtual Machine is stored in Azure Keyvault.
      3. Only Web VM is exposed to users via Load Balancer and all other inbound traffic is blocked.
      4. App VM is accessible via Web VM only and all other inbound traffic is blocked.
      4. MySQLServer admin password is stored in KeyVault.
      5. Web VM and App VM are placed in seperate Subnets and only particular ports would be allowed.
      6. No communication between Web VM and MySQL DB PaaS
      
#### Additional Security which could be followed:-
      1. Use of Private Endpoints and Private link services to connect to Resources.
         For instance :-
                a. Instead of using Public Load Balancer, we could have used internal load balancer and exposed its services using Private Link Services.
                b. MYSQL DB could be exposed using Private Endpoints.
                c. Azure Keyvault could be exposed with Private Endpoints
      2. Blocking all the outbound traffic from the VMs and only allowing selected ports.
