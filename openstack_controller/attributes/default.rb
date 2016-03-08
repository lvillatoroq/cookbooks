
##Controller Node Attributes
default['openstack']['controller']['hostname'] = 'controller'
default['openstack']['controller']['mgmtinterface'] = 'eth1'
default['openstack']['controller']['mgmtip'] = '192.168.88.200'
default['openstack']['controller']['mgmtmask'] = '255.255.255.0'
default['openstack']['controller']['gateway'] = '192.168.88.1'
default['openstack']['controller']['publicinterface'] = 'eth2'
default['openstack']['internet'] = 'eth4'
default['apt']['unattended_upgrades']['enable'] = true
default['mariadb']['password']= 'telematica'
##DNS (Please Add the corresponding entries according to your setup)
default['openstack']['dns']['compute1'] = 'compute1'
default['openstack']['dns']['compute1ip'] = '192.168.88.201'
default['openstack']['dns']['compute2'] = 'compute2'
default['openstack']['dns']['compute2ip'] = '192.168.88.202'
default['openstack']['dns']['compute3'] = 'compute3'
default['openstack']['dns']['compute3ip'] = '192.168.88.203'
default['openstack']['dns']['block'] = 'block1'
default['openstack']['dns']['blockip'] = '192.168.88.204'
##MongoDB Attributes
default['mongodb']['config']['smallfiles'] = true
default['mongodb']['config']['bind_ip'] = '0.0.0.0'

