#
# Cookbook Name:: system_info
# Recipe:: default
#
# Copyright 2014, Travis CI GmbH
#
# MIT License
#

git '/usr/local/system_info' do
  repository 'https://github.com/travis-ci/system_info.git'
  revision 'master'
  action :sync
end

execute "set owner on /usr/local/system_info" do
  command "chown -R #{node.travis_build_environment.user}:#{node.travis_build_environment.group} /usr/local/system_info"
end

directory '/usr/share/travis' do
  owner node.travis_build_environment.user
  group node.travis_build_environment.group
  recursive true
end

bash 'Install system_info gems' do
  user node.travis_build_environment.user
  cwd  '/usr/local/system_info'
  code <<-EOF
    bundle install --deployment
  EOF
end