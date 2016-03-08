#
# Cookbook Name:: openstack_controller
# Recipe:: keystone
#
# Copyright (c) 2016 The Authors, All Rights Reserved.


##Initialize MySQL for Keystone

cookbook_file '/tmp/keystone.sql' do
	source 'keystone.sql'
	owner 'root'
	group 'root'
	mode '0600'
end

execute 'keystone_initdb' do 
	command "mysql -u root -p#{node['mariadb']['password']} < /tmp/keystone.sql"
end

#Install the Keystone and Keystone client packages

execute "disable_keystone" do 
	command "echo 'manual' > /etc/init/keystone.override"
end

package ['keystone', 'apache2', 'libapache2-mod-wsgi', 'memcached', 'python-memcache'] do 
	ignore_failure true
end

cookbook_file "keystone.conf" do
	path "/etc/keystone/keystone.conf"
	action :create
end

execute "keystone-manage db_sync" do 
	user "root"
	group "root"
end

template "/etc/apache2/apache2.conf" do
	source "apache2.conf.erb"
	owner "root"
	group "root"
	mode 0644
end

template "/etc/apache2/sites-available/wsgi-keystone.conf" do
	source "wsgi-keystone.conf.erb"
	owner "root"
	group "root"
	mode 0644
end

execute 'symlink' do
	command 'ln -s /etc/apache2/sites-available/wsgi-keystone.conf /etc/apache2/sites-enabled'
end

service 'apache2' do
	action :restart
end

file '/var/lib/keystone/keystone.db' do
	action :delete
end