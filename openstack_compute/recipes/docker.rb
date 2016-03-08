#
# Cookbook Name:: openstack_compute
# Recipe:: docker
#
# Copyright (c) 2016 The Authors, All Rights Reserved.



cookbook_file '/etc/apt/sources.list.d/docker.list' do
	source 'docker.list'
	owner 'root'
	group 'root'
	mode '0600'
end

execute 'aptupdate' do
	command 'apt-get update'
end

execute 'imagelinux' do
	command 'apt-get install linux-image-extra-$(uname -r)'
end

package 'docker-engine' do
	ignore_failure true
end

service 'docker' do 
	action :start
	ignore_failure true
end

group 'docker' do
	members 'nova'
	append true
end 


