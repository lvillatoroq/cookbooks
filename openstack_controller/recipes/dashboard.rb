#
# Cookbook Name:: openstack_controller
# Recipe:: dashboard
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

package 'openstack-dashboard' do
	ignore_failure true
end

cookbook_file "local_settings.py" do
	path "/etc/openstack-dashboard/local_settings.py"
	action :create
end

service 'apache2' do 
	action :restart
end