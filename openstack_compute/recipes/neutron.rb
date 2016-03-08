#
# Cookbook Name:: openstack_compute
# Recipe:: neutron
#
# Copyright (c) 2016 The Authors, All Rights Reserved.


package ['neutron-plugin-linuxbridge-agent','conntrack'] do
	ignore_failure true
end

cookbook_file "neutron.conf" do
	path "/etc/neutron/neutron.conf"
	action :create
end

template "/etc/neutron/plugins/ml2/linuxbridge_agent.ini" do
	source "linuxbridge_agent.ini.erb"
	owner "root"
	group "root"
	mode 0644
end

service 'nova-compute' do
	action :restart
end

service 'neutron-plugin-linuxbridge-agent' do
	action :restart
	ignore_failure true
end
