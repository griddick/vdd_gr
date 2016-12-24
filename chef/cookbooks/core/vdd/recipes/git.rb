package "git" do
  action :install
end

template "/home/ubuntu/.gitconfig" do
  source "gitconfig.erb"
  owner "ubuntu"
  group "ubuntu"
  mode "0644"
end
