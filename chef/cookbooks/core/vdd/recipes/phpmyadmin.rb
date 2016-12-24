#create a default mysql socket location for deb-conf to be happy
directory "/var/run/mysql" do
  owner "root"
  group "root"
  mode 00755
  action :create
end

deb_conf_file = "/tmp/phpmyadmin.deb.conf"

template deb_conf_file do
  source "phpmyadmin.deb.conf.erb"
end

ruby_block "Set socket file location" do
  block do
    fe = Chef::Util::FileEdit.new("/etc/mysql/debian.cnf")
    fe.search_file_replace_line('/^socket/', 'socket = /var/run/mysql-default/mysqld.sock')
    fe.write_file
  end
end

bash "debconf" do
  code "debconf-set-selections #{deb_conf_file}"
end

bash "enable_apache_module_authz_user" do
  user "root"
  code <<-EOH
  a2enmod authz_user
  EOH
  not_if { File.exists?("/etc/apache2/mods-enabled/authz_user") }
end

#Create a link to the socket location that dbconfig-common expects
directory "/var/run/mysqld" do
  owner "root"
  group "root"
  mode 00755
  action :create
end
link '/var/run/mysqld/mysqld.sock' do
  to '/var/run/mysql-default/mysqld.sock'
end

package "phpmyadmin" do
  action :install
end

directory "/var/lib/phpmyadmin/tmp" do
  owner "ubuntu"
  group "www-data"
  mode 00755
  action :create
end

template "/var/lib/phpmyadmin/config.inc.php" do
  source "phpmyadmin.dbconf.erb"
  mode "0644"
end

