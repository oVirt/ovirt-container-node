#!/bin/python
from vdsm import vdscli
import socket

c = vdscli.connect()
network_attrs = {'nics': 'eth0',
                 'ipaddr': socket.gethostbyname(socket.gethostname()),
                 'netmask': '255.255.255.0',
                 'defaultRoute': True,
                 'bridged': True}

c.setupNetworks({'ovirtmgmt': network_attrs}, {}, {'connectivityCheck': False})
