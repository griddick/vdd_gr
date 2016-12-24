package "php-apcu" do
  action :install
end

template "/etc/php/7.0/apache2/conf.d/vdd_apc.ini" do
  source "vdd_apc.ini.erb"
  mode "0644"
  notifies :restart, "service[apache2]", :delayed
end
