#
# Cookbook Name:: openstack_controller
# Recipe:: environment
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

##Configure Management Interface

template "/etc/network/interfaces" do
	source "interfaces.erb"
	owner "root"
	group "root"
	mode 0644
end

execute 'ifdownint' do
		command "ifdown #{node['openstack']['controller']['mgmtinterface']}"
end

execute 'ifupint' do
		command "ifup #{node['openstack']['controller']['mgmtinterface']}"
end

execute 'ifdownint2' do
		command "ifdown #{node['openstack']['controller']['publicinterface']}"
end

execute 'ifupint2' do
		command "ifup #{node['openstack']['controller']['publicinterface']}"
end

##Change the Hostname
template "/etc/hostname" do
	source "hostname.erb"
	owner "root"
	group "root"
	mode 0644
end

service "hostname" do
	action :restart
	ignore_failure true
end

##Add DNS Entries for Other Openstack service nodes(Update other nodes by DNS)
template "/etc/hosts" do
	source "hosts.erb"
	owner "root"
	group "root"
	mode 0644
end

package 'software-properties-common' do
	action [:install, :upgrade]
	ignore_failure true
end

execute "add_repo" do 
	command "add-apt-repository cloud-archive:liberty"
end

execute 'updaterep' do
	command 'apt-get update'
end
