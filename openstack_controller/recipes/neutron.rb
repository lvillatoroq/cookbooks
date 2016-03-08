#
# Cookbook Name:: openstack_controller
# Recipe:: neutron
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

cookbook_file '/tmp/neutron.sql' do
	source 'neutron.sql'
	owner 'root'
	group 'root'
	mode '0600'
end

execute 'neutron_initdb' do 
	command "mysql -u root -p#{node['mariadb']['password']} < /tmp/neutron.sql"
end

package ['neutron-server','neutron-plugin-ml2','neutron-plugin-linuxbridge-agent','neutron-l3-agent','neutron-dhcp-agent','neutron-metadata-agent','python-neutronclient','conntrack'] do
	ignore_failure true
end

cookbook_file "neutron.conf" do
	path "/etc/neutron/neutron.conf"
	action :create
end

cookbook_file "dnsmasq-neutron.conf" do
	path "/etc/neutron/dnsmasq-neutron.conf"
	action :create
end

cookbook_file "ml2_conf.ini" do
	path "/etc/neutron/plugins/ml2/ml2_conf.ini"
	action :create
end

template "/etc/neutron/plugins/ml2/linuxbridge_agent.ini" do
	source "linuxbridge_agent.ini.erb"
	owner "root"
	group "root"
	mode 0644
end

cookbook_file "l3_agent.ini" do
	path "/etc/neutron/l3_agent.ini"
	action :create
end

cookbook_file "dhcp_agent.ini" do
	path "/etc/neutron/dhcp_agent.ini"
	action :create
end

cookbook_file "metadata_agent.ini" do
	path "/etc/neutron/metadata_agent.ini"
	action :create
end

execute "neutrondb" do
	command 'neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head'
end

service 'nova-api' do
	action :restart
end

service 'neutron-server' do
	action :restart
end

service 'neutron-plugin-linuxbridge-agent' do
	action :restart
end

service 'neutron-dhcp-agent' do
	action :restart
end

service 'neutron-metadata-agent' do
	action :restart
end

service 'neutron-l3-agent' do
	action :restart
end

file '/var/lib/neutron/neutron.sqlite' do
	action :delete
end