# Determine if the directory is NFS.
nfs = 0
node["vm"]["synced_folders"].each do |folder|
  if folder['guest_path'] == '/var/www'
    if folder['type'] == 'nfs'
      nfs = 1
    end
  end
end

mysql_client 'default' do
  action :create
end

mysql_service 'default' do
  version '5.7'
  initial_root_password node["mysql"]["server_root_password"]
  action [:create, :start]
end

mysql_config 'default' do
  source 'vdd_my.cnf.erb'
  notifies :restart, 'mysql_service[default]'
  action :create
end


mysql2_chef_gem 'default' do
  action :install
end

template "/home/ubuntu/.my.cnf" do
  source "vdd_user.my.cnf.erb"
  mode "0644"
  notifies :restart, "mysql_service[default]", :delayed
end

if node["vdd"]["sites"]
   node["vdd"]["sites"].each do |index, site|

    htdocs = defined?(site["vhost"]["document_root"]) ? site["vhost"]["document_root"] : index

    # Avoid potential duplicate slash in docroot path from config.json input.
    if htdocs.start_with?("/")
      htdocs = htdocs[1..-1]
    end
    # Create subidrectores, allow for multiple layers deep.
    htdocs = "var/www/" + htdocs
    htdocs = htdocs.split(%r{\/\s*})
    folder = "/"
    for i in (0..htdocs.length - 1)
      folder = folder + htdocs[i] + "/"
      directory folder do
        if nfs == 0
          owner "ubuntu"
          group "ubuntu"
          mode "0755"
        end
        action :create
      end
    end

    mysql_connection_info = {
      :host => "localhost",
      :username => "root",
      :password => node["mysql"]["server_root_password"],
      :socket   => "/var/run/mysql-default/mysqld.sock"
    }
    mysql_database index do
      connection mysql_connection_info
      action :create
    end

  end
end
