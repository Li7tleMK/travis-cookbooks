include_recipe "java"

# Cloudera only provides 64 bit packages. MK.
apt_repository "cdh4" do
  uri          "http://archive.cloudera.com/cdh4/ubuntu/#{node['lsb']['codename']}/amd64/cdh"
  distribution "#{node['lsb']['codename']}-cdh4"
  components   ["contrib"]
  options      "arch=amd64"
  key          "http://archive.cloudera.com/cdh4/ubuntu/#{node['lsb']['codename']}/amd64/cdh/archive.key"

  action :add
end

package "hbase" do
  action :install
end

package "hbase-master" do
  action :install
end

service "hbase-master" do
  supports :start => true, :stop => true, :restart => true
  action [:disable, :start]
end