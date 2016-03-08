# cookbooks
Chef cookbooks for Openstack Liberty

This cookbooks install the necessary components that a controller/compute node needs. Each component has its independent recipe that can be reused to install a particular component as needed.

-Keystone
-glance
-Neutron (with self-service networks)
-Nova (NFS Live Migrations enabled) 

The controller/compute node needs to have two NIC, one for the management network and the other as the public network following the example arquitecture found on http://docs.openstack.org/liberty/install-guide-ubuntu/

#Requirements 
clone the repository 

git clone https://github.com/lvillatoroq/cookbooks.git

In order for the cookbook to work, the following requirements are needed

Install chef client from https://downloads.chef.io/chef-client/

OS: Ubuntu 14.04 (tested on this operating system, may work on newer versions)
Packages: mariadb sql server (apt-get install mariadb-server) * only for controller node 

#Instructions

Please modify the default.rb file in the attributes folder to match those of your setup (network interfaces, user, mysql password).
Run the default recipe in order to install the complete controller/compute node.

To Install controller node run chef client in local mode using the following command 

sudo chef-client -z -r "recipe[openstack_controller]"

To Install compute node run chef client in local mode using the following command 

sudo chef-client -z -r "recipe[openstack_compute]"
