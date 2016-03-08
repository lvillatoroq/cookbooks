#
# Cookbook Name:: openstack_controller
# Recipe:: glance
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

##Initialize MySQL for Keystone

cookbook_file '/tmp/glance.sql' do
	source 'glance.sql'
	owner 'root'
	group 'root'
	mode '0600'
end

execute 'glance_initdb' do 
	command "mysql -u root -p#{node['mariadb']['password']} < /tmp/glance.sql"
end

package ['glance','python-glanceclient','nfs-kernel-server'] do
	ignore_failure true
end

cookbook_file "exports" do
	path "/etc/exports"
	action :create
end

service 'nfs-kernel-server' do
	action :restart
end

service 'idmapd' do
	action :restart
end

cookbook_file "glance-api.conf" do
	path "/etc/glance/glance-api.conf"
	action :create
end

cookbook_file "glance-registry.conf" do
	path "/etc/glance/glance-registry.conf"
	action :create
end

execute "glance-manage db_sync" do 
	user "root"
	group "root"
end

service 'glance-registry' do 
	action :restart
end

service 'glance-api' do	
	action :restart
end

execute 'delete_db' do
	command 'rm -f /var/lib/glance/glance.sqlite'
end
