#Authentication
tenant_id       = "7d64ac83-6c0c-4d7e-8f16-301f23062ebf"
subscription_id = "ea19577d-ae3c-4081-be3c-42ed78190083"
client_id       = "9704b345-a50f-4f1f-94a5-44ca2d0dbcae"
client_secret   = "nXguYzy5A._X96N54K.3owqJq0~UUAjtQL"
object_id       = "9034ba49-d4af-4e89-8889-3d7db26d5f3b"
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