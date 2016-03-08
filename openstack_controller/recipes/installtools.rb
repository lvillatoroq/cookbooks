#
# Cookbook Name:: openstack_controller
# Recipe:: installtools
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

##Install the Packages 
package ['python-openstackclient','python-pymongo','python-pymysql','rabbitmq-server','dnsmasq'] do 
	ignore_failure true
end

#Install the mysql services 

=begin
template "/etc/mysql/conf.d/mysqld_openstack.cnf" do
	source "mysqld_openstack.cnf.erb"
	owner "root"
	group "root"
	mode 0644
end

service 'mysql' do 
  action :restart
end
=end

execute 'addusrabbit' do
  command 'rabbitmqctl add_user openstack openstack'
  ignore_failure true
end

execute 'permitusrabbit' do
  command "rabbitmqctl set_permissions openstack '.*' '.*' '.*'"
  ignore_failure true
end

##Configure DNS entries

template "/etc/dnsmasq.conf" do
	source "dnsmasq.conf.erb"
	owner "root"
	group "root"
	mode 0644
end

service 'dnsmasq' do
	action :stop
	ignore_failure true
end

service 'dnsmasq' do
	action :start
	ignore_failure true
end
