#
# Cookbook Name:: ssh_tunnel
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package "autossh" do
 action :install
end

data_bag('ssh_tunnel').each do |tunnel|
tun = data_bag_item('ssh_tunnel', tunnel).raw_data
 case tun["action"]
  when "add"
   template "/etc/init.d/#{tunnel}" do
     source "ssh_tunnel.initd.erb"
     owner 'root'
     group 'root'
     mode 0755
     variables(tun)
   end
   service(tunnel) do
    action [:enable,:restart]
   end
 when "delete"
   service(tunnel) do
    action [:disable,:stop]
   end
 when "restart"
   service(tunnel) do
    action :restart
   end
 else 
   service(tunnel) do
    action :nothing
   end
 end
end
