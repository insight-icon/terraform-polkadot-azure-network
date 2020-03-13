resource "azurerm_network_security_group" "monitoring_nsg" {
  count               = var.monitoring_enabled ? 1 : 0
  location            = data.azurerm_resource_group.this.location
  name                = "${var.monitoring_sg_name}-nsg"
  resource_group_name = data.azurerm_resource_group.this.name
  tags                = module.label.tags
}

resource "azurerm_application_security_group" "monitoring_asg" {
  count               = var.monitoring_enabled ? 1 : 0
  location            = data.azurerm_resource_group.this.location
  name                = "${var.monitoring_sg_name}-asg"
  resource_group_name = data.azurerm_resource_group.this.name
  tags                = module.label.tags
}

resource "azurerm_network_security_rule" "monitoring_sg_ssh" {
  count                       = var.monitoring_enabled && ! var.bastion_enabled ? 1 : 0
  name                        = "${var.monitoring_sg_name}-ssh"
  access                      = "Allow"
  direction                   = "Inbound"
  network_security_group_name = azurerm_network_security_group.monitoring_nsg[0].name
  priority                    = 100
  resource_group_name         = data.azurerm_resource_group.this.name

  protocol                                   = "tcp"
  source_address_prefixes                    = var.corporate_ip == "" ? ["0.0.0.0/0"] : ["${var.corporate_ip}/32"]
  source_port_range                          = "22"
  destination_application_security_group_ids = [azurerm_application_security_group.monitoring_asg[0].name]
}

resource "azurerm_network_security_rule" "monitoring_sg_bastion_ssh" {
  count                       = var.monitoring_enabled && var.bastion_enabled ? 1 : 0
  name                        = "${var.monitoring_sg_name}-ssh"
  access                      = "Allow"
  direction                   = "Inbound"
  network_security_group_name = azurerm_network_security_group.monitoring_nsg[0].name
  priority                    = 100
  resource_group_name         = data.azurerm_resource_group.this.name

  protocol                                   = "tcp"
  source_application_security_group_ids      = [azurerm_application_security_group.bastion_asg[0].name]
  source_port_range                          = "22"
  destination_application_security_group_ids = [azurerm_application_security_group.monitoring_asg[0].name]
}

resource "azurerm_network_security_rule" "monitoring_sg_http_ingress" {
  count                       = var.monitoring_enabled ? 1 : 0
  name                        = "${var.monitoring_sg_name}-http_ingress"
  access                      = "Allow"
  direction                   = "Inbound"
  network_security_group_name = azurerm_network_security_group.monitoring_nsg[0].name
  priority                    = 100
  resource_group_name         = data.azurerm_resource_group.this.name

  protocol                                   = "tcp"
  source_address_prefix                      = "0.0.0.0/0"
  source_port_range                          = "80"
  destination_application_security_group_ids = [azurerm_application_security_group.monitoring_asg[0].name]
}

resource "azurerm_network_security_rule" "monitoring_sg_consul" {
  count                       = var.monitoring_enabled && var.consul_enabled ? 1 : 0
  name                        = "${var.monitoring_sg_name}-consul"
  access                      = "Allow"
  direction                   = "Inbound"
  network_security_group_name = azurerm_network_security_group.monitoring_nsg[0].name
  priority                    = 100
  resource_group_name         = data.azurerm_resource_group.this.name

  protocol                              = "*"
  source_application_security_group_ids = [azurerm_application_security_group.consul_asg[0].name]
  source_port_ranges = ["8600",
    "8500",
    "8301",
  "8302"]
  destination_application_security_group_ids = [azurerm_application_security_group.monitoring_asg[0].name]
}