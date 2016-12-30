#!/bin/bash
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
DHCP_IP=$(grep dhcp $SCRIPTPATH/../config-files/IPs | awk -F= '{print $2}')
NETMASK=$(grep netmask $SCRIPTPATH/../config-files/IPs | awk -F= '{print $2}')
NETMASK_PREFIX=$(docker run --rm ehudkaldor/helper ipcalc -p $DHCP_IP $NETMASK | awk -F= '{print $2}')

echo $DHCP_IP
echo $NETMASK
echo $NETMASK_PREFIX
echo $SCRIPTPATH
echo $HOME_GATEWAY_CONFIG_PATH/containers/isc-dhcp/etc/dhcp

docker kill dhcp
docker rm dhcp
DHCP_CONTAINER=$( \
	docker run -d \
	--privileged \
	-v $HOME_GATEWAY_CONFIG_PATH/containers/isc-dhcp/etc/dhcp:/etc/dhcp \
	-v $HOME_GATEWAY_CONFIG_PATH/containers/isc-dhcp/var/lib/dhcp/:/var/lib/dhcp/ \
	--name dhcp \
	ehudkaldor/isc-dhcp \
)
echo container ID: $DHCP_CONTAINER
sudo $PIPEWORK br0 $DHCP_CONTAINER $DHCP_IP/$NETMASK_PREFIX
