#
# Cookbook Name:: openstack_controller
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.


include_recipe 'apt::default'
include_recipe 'openstack_controller::environment'
include_recipe 'openstack_controller::installtools'
include_recipe 'openstack_controller::keystone'
include_recipe 'openstack_controller::userendpoints'
include_recipe 'openstack_controller::glance'
include_recipe 'openstack_controller::nova'
include_recipe 'openstack_controller::neutron'
include_recipe 'openstack_controller::dashboard'
##include_recipe 'mongodb::default'


