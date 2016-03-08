#
# Cookbook Name:: openstack_controller
# Recipe:: userendpoints
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

##Initialize Enviroment variables
ENV['OS_TOKEN'] = "telematica"
ENV['OS_URL'] = "http://controller:35357/v3"
ENV['OS_IDENTITY_API_VERSION']= '3'


execute "create_service" do 
	command 'openstack service create --name keystone --description "Openstack Identity" identity'
end 

execute "create_endpoint_public" do 
	command 'openstack endpoint create --region RegionOne identity public http://controller:5000/v2.0'
end 

execute "create_endpoint_internal" do 
	command 'openstack endpoint create --region RegionOne identity internal http://controller:5000/v2.0'
end

execute "create_endpoint_admin" do 
	command 'openstack endpoint create --region RegionOne identity admin http://controller:5000/v2.0'
end

execute "create_admin_project" do 
	command 'openstack project create --domain default --description "Admin Project" admin'
end 

execute "create_admin_user" do 
	command 'openstack user create --domain default --password telematica admin'
end

execute "create_admin_role" do 
	command 'openstack role create admin'
end 

execute "assign_role_user" do 
	command 'openstack role add --project admin --user admin admin'
end 

execute "create_service_project" do 
	command 'openstack project create --domain default --description "Service Project" service'
end

execute "create_demo_project" do 
	command 'openstack project create --domain default --description "Demo Project" demo'
end

execute "create_demo_user" do 
	command 'openstack user create --domain default --password telematica demo'
end 

execute "create_user_role" do 
	command 'openstack role create user'
end 

execute "assign_demo_role" do 
	command 'openstack role add --project demo --user demo user'
end 

##Create Glance Service credentials and endpoints

execute "glance-user" do
	command 'openstack user create --domain default --password glance glance'
end

execute "glancerole" do 
	command 'openstack role add --project service --user glance admin'
end 

execute "glanceentity" do 
	command 'openstack service create --name glance --description "Openstack Image Service" image'
end 

execute "sleep3" do 
	command "sleep 3s"
end

execute "glancendpoint" do 
	command 'openstack endpoint create --region RegionOne image public http://controller:9292'
end

execute "glancendpoint2" do 
	command 'openstack endpoint create --region RegionOne image internal http://controller:9292'
end

execute "glancendpoint" do 
	command 'openstack endpoint create --region RegionOne image admin http://controller:9292'
end 

##Create Nova Service credentials and endpoints

execute 'nova-user' do 
	command 'openstack user create --domain default --password nova nova'
end 

execute 'nova-role' do 
	command 'openstack role add --project service --user nova admin'
end

execute 'nova-service' do 
	command 'openstack service create --name nova --description "OpenStack Compute" compute'
end

execute 'nova-endpoint1' do 
	command 'openstack endpoint create --region RegionOne compute public http://controller:8774/v2/%\(tenant_id\)s'
end 

execute 'nova-endpoint2' do 
	command 'openstack endpoint create --region RegionOne compute internal http://controller:8774/v2/%\(tenant_id\)s'
end 

execute 'nova-endpoint3' do 
	command 'openstack endpoint create --region RegionOne compute admin http://controller:8774/v2/%\(tenant_id\)s'
end 

##Neutron Service and User Endpoints
execute 'neutron-user' do 
	command 'openstack user create --domain default --password neutron neutron'
end 

execute 'neutron-role' do 
	command 'openstack role add --project service --user neutron admin'
end

execute 'neutron-service' do 
	command 'openstack service create --name neutron --description "OpenStack Networking" network'
end

execute 'neutron-endpoint' do 
	command 'openstack endpoint create --region RegionOne network public http://controller:9696'
end

execute 'neutron-endpoint2' do 
	command 'openstack endpoint create --region RegionOne network internal http://controller:9696'
end

execute 'neutron-endpoint3' do 
	command 'openstack endpoint create --region RegionOne network admin http://controller:9696'
end

