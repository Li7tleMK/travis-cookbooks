#
# Cookbook Name:: travis_build_environment
# Recipe:: default
# Copyright 2011, Travis CI development team
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

include_recipe "timezone"
include_recipe "timetrap"

include_recipe "travis_build_environment::root"
include_recipe "travis_build_environment::vagrant"

cookbook_file "/etc/default/locale" do
  owner "root"
  group "root"
  mode 0644

  source "etc/default/locale.sh"
end

template "/etc/hosts" do
  owner "root"
  group "root"
  mode 0644

  source "etc/hosts.erb"
end

include_recipe "iptables"


case [node[:platform], node[:platform_version]]
# wipe out apparmor on 11.04, it may be a useful thing for typical servers but
# in our case it is a major annoyance and nothing else. MK.
when ["ubuntu", "11.04"] then
  package "apparmor" do
    action :remove
  end

  package "apparmor-utils" do
    action :remove
  end
end

execute "rm /etc/update-motd.d/*"
