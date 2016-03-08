#
# Cookbook Name:: openstack_compute
# Recipe:: nova
#
# Copyright (c) 2016 The Authors, All Rights Reserved.


group 'nova' do
	gid '1018'
end

group 'kvm' do
	gid '1012'
end

user 'nova' do
	uid '1012'
	gid '1018'
	home '/var/lib/nova'
	shell '/bin/bash'
	action :create
end

user 'libvirt-qemu' do
	uid '1007'
	gid '1012'
	comment 'Libvirt Qemu,,,'
	home '/var/lib/libvirt'
	shell '/bin/false'
	action :create
end

package ['nova-compute','sysfsutils','nfs-common'] do
	ignore_failure true
end

template "/etc/nova/nova.conf" do
	source "nova.conf.erb"
	owner "root"
	group "root"
	mode 0644
end

service 'nova-compute' do
	action :restart
end

execute 'delfilesql' do
	command 'rm -f /var/lib/nova/nova.sqlite'
end

execute 'enablenfs' do
	command 'chmod o+x /var/lib/nova/instances'
end

append_line "/etc/fstab" do
	line "controller: /var/lib/nova/instances nfs4 defaults 0 0"
end

execute 'montarnfs' do
	command 'mount -a -v'
	ignore_failure true
end

cookbook_file "libvirtd.conf" do
	path "/etc/libvirt/libvirtd.conf"
	action :create
end

cookbook_file "libvirt-bin.conf" do
	path "/etc/init/libvirt-bin.conf"
	action :create
end

cookbook_file "libvirt-bin" do
	path "/etc/default/libvirt-bin"
	action :create
end

directory '/var/lib/nova/.ssh' do
  owner 'nova'
  group 'nova'
  mode '0700'
  action :create
end

=begin
ruby_block "setuuid" do
    block do
        #tricky way to load this Chef::Mixin::ShellOut utilities
        Chef::Resource::RubyBlock.send(:include, Chef::Mixin::ShellOut)      
        command = 'uuidgen'
        command_out = shell_out(command)
        node.set['my_uuid'] = command_out.stdout
    end
    action :create
end

append_line "/etc/libvirt/libvirtd.conf" do
	line "host_uuid="
end
=end

execute 'generateuuid' do
	command 'echo "host_uuid=\"$(uuidgen)\"" >> /etc/libvirt/libvirtd.conf'
end

execute 'enablenovassh' do
	command 'usermod -s /bin/bash nova'
end

cookbook_file "id_rsa" do
	path "/var/lib/nova/.ssh/id_rsa"
	action :create
end

cookbook_file "config" do
	path "/var/lib/nova/.ssh/config"
	action :create
end

template "/var/lib/nova/.ssh/authorized_keys" do
	source "authorized_keys.erb"
	owner "nova"
	group "nova"
	mode 0600
end
