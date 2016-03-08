#
# Cookbook Name:: openstack_controller
# Recipe:: nova
#
# Copyright (c) 2016 The Authors, All Rights Reserved.


cookbook_file '/tmp/nova.sql' do
	source 'nova.sql'
	owner 'root'
	group 'root'
	mode '0600'
end

execute 'nova_initdb' do 
	command "mysql -u root -p#{node['mariadb']['password']} < /tmp/nova.sql"
end

group 'nova' do
	gid '1018'
end

user 'nova' do
	uid '1012'
	gid '1018'
	home '/var/lib/nova'
	shell '/bin/false'
	action :create
end

package ['nova-api','nova-cert','nova-conductor','nova-consoleauth','nova-novncproxy','nova-scheduler','python-novaclient'] do
	ignore_failure true
end

template "/etc/nova/nova.conf" do
	source "nova.conf.erb"
	owner "root"
	group "root"
	mode 0644
end

execute "nova-manage db sync" do 
	user "root"
	group "root"
end

service "nova-api" do	
	action :restart
end

service "nova-cert" do
	action :restart
end

service "nova-consoleauth" do
    action :restart
end

service "nova-scheduler" do
    action :restart
end

service "nova-conductor" do
    action :restart
end

service "nova-novncproxy" do
    action :restart
end

file '/var/lib/nova/nova.sqlite' do
	action :delete
end
