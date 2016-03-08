#
# Cookbook Name:: openstack_compute
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe 'apt::default'
include_recipe 'openstack_compute::environment'
include_recipe 'openstack_compute::nova'
include_recipe 'openstack_compute::neutron'
