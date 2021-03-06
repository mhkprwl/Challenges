#Authentication
tenant_id       = "****"
subscription_id = "****"
client_id       = "****"
client_secret   = "****"
object_id       = "****"
#########
rgname          = "poc-eastus2-rg-01"
location        = "eastus2"

vnetname        = "poc-eastus2-vnet-01"
websubnetname   = "poc-eastus2-web-snet-01"
appsubnetname   = "poc-eastus2-app-snet-01"

webnsgname      = "poc-eastus2-web-nsg-01"
appnsgname      = "poc-eastus2-app-nsg-01"

lbpip           = "poc-eastus2-web-lb-pip"
lbname          = "poc-eastus2-web-lb-01"
frontend_name   = "poc-eastus2-web-lb-fe"

webvmnic        = "poc-eastus2-web-vm-nic"
webvmname       = "poc-eastus2-web-vm-01"
appvmnic        = "poc-eastus2-app-vm-nic"
appvmname       = "poc-eastus2-app-vm-01"
vm_admin_username = "adminuser"

kvname          = "poc-eastus2-kv-01"
sqlsrvname      = "poc-eastus2-mysql-01"
mysql_sku_name  = "B_Gen5_1"
mysql_version   = "5.7"
sqlsrvdbname    = "mysqldb"
db_administrator_login_name = "dbadmin"
