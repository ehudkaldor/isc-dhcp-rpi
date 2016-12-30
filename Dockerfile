################################################
#
#
#
#
#
################################################

FROM		ehudkaldor/alpine-s6-rpi:latest
MAINTAINER	Ehud Kaldor <ehud.kaldor@gmail.com>

RUN 		apk add --update dhcp && \
		rm -rf /var/cache/apk/*

#ADD	        https://raw.github.com/jpetazzo/pipework/master/pipework pipework

#RUN        	chmod +x pipework

# VOLUME	/var/lib/dhcp/ && \
RUN		  mkdir -p /var/lib/dhcp/ && \
			  touch /var/lib/dhcp/dhcpd.leases
#		mkdir -p /etc/dhcp/

COPY 		rootfs /

RUN     	ln -s /bin/s6-true /etc/services.d/isc-dhcp/finish


#USER		root

#CMD		\
#   		echo Setting up iptables... && \
#	   	iptables -t nat -A POSTROUTING -j MASQUERADE && \
#   		echo Waiting for pipework to give us the eth1 interface... &&\
#   		./pipework --wait && \
#   		echo Starting ISC-DHCP server on eth1... && \
#		dhcpd -f -cf /etc/dhcp/dhcpd.conf eth1
