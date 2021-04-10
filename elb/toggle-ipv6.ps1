# Disable IPv6

Disable-NetAdapterBinding -Name * -ComponentID ms_tcpip6

# Enable IPv6

Enable-NetAdapterBinding -Name * -ComponentID ms_tcpip6