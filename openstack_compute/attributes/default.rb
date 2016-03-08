##Compute Node Attributes
##please change the hostname for each compute node ej compute1 compute2 compute3 and UPDATE DNS SECTION BELOW!!!!
default['openstack']['compute']['hostname'] = 'compute1'
default['openstack']['compute']['mgmtinterface'] = 'eth1'
default['openstack']['compute']['mgmtip'] = '192.168.88.201'
default['openstack']['compute']['mgmtmask'] = '255.255.255.0'
default['openstack']['compute']['gateway'] = '192.168.88.1'
default['openstack']['compute']['publicinterface'] = 'eth2'
default['openstack']['internet'] = 'eth4'
default['apt']['unattended_upgrades']['enable'] = true
default['systemuser'] = 'root'

##DNS (Please Add the corresponding entries according to your setup)
default['openstack']['controller']['mgmtip'] = '192.168.88.200'
default['openstack']['dns']['compute1'] = 'compute1'
default['openstack']['dns']['compute1ip'] = '192.168.88.201'
default['openstack']['dns']['compute2'] = 'compute2'
default['openstack']['dns']['compute2ip'] = '192.168.88.202'
default['openstack']['dns']['compute3'] = 'compute3'
default['openstack']['dns']['compute3ip'] = '192.168.88.203'
default['openstack']['dns']['block'] = 'block1'
default['openstack']['dns']['blockip'] = '192.168.88.204'
