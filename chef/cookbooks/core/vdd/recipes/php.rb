include_recipe 'php'

pkgs = [
  "libapache2-mod-php7.0",
  "php7.0-gd",
  "php7.0-mysql",
  "php7.0-mcrypt",
  "php7.0-curl",
  "php7.0-dev",
]

pkgs.each do |pkg|
  package pkg do
    action :install
  end
end

template "/etc/php/7.0/apache2/conf.d/vdd_php.ini" do
  source "vdd_php.ini.erb"
  mode "0644"
  notifies :restart, "service[apache2]", :delayed
end

#Need it for the cli too to allow drush to work properly
template "/etc/php/7.0/cli/conf.d/vdd_php.ini" do
  source "vdd_php.ini.erb"
  mode "0644"
end
