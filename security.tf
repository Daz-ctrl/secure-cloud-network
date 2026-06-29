# ==========================================
# 1. PRIVATE TIER: PERIMETER SECURITY
# ==========================================
resource "azurerm_network_security_group" "private_nsg" {
  name                = "nsg-private-tier-001"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "Allow-Traffic-From-Public-Subnet"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.0.1.0/24"   # Public DMZ Subnet
    destination_address_prefix = "10.0.2.0/24"   # Private Subnet
  }

  security_rule {
    name                       = "Deny-Direct-Internet-Inbound"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "Internet"
    destination_address_prefix = "10.0.2.0/24"
  }
}

resource "azurerm_subnet_network_security_group_association" "private_assoc" {
  subnet_id                 = azurerm_subnet.private_subnet.id
  network_security_group_id = azurerm_network_security_group.private_nsg.id
}


# ==========================================
# 2. PUBLIC TIER: DMZ SECURITY 
# ==========================================
resource "azurerm_network_security_group" "public_nsg" {
  name                = "nsg-public-dmz-001"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "Deny-Unsolicited-Internet-Inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "Internet"
    destination_address_prefix = "10.0.1.0/24"
  }
}

resource "azurerm_subnet_network_security_group_association" "public_assoc" {
  subnet_id                 = azurerm_subnet.public_subnet.id
  network_security_group_id = azurerm_network_security_group.public_nsg.id
}